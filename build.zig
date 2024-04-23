const std = @import("std");
const abs = @import("abs");
const builtin = @import("builtin");

const is_threaded = !builtin.single_threaded;

pub fn build(b: *std.Build) !void {
    // ldc2/ldmd2 not have mingw-support
    const target = b.standardTargetOptions(.{
        .default_target = if (builtin.os.tag == .windows)
            try std.Target.Query.parse(.{
                .arch_os_abi = "native-windows-msvc",
            })
        else
            .{},
    });
    const optimize = b.standardOptimizeOption(.{});

    const bdwgc = buildLibGC(b, .{ target, optimize });
    const libgc = bdwgc.artifact("gc");
    const libgccxx = bdwgc.artifact("gccpp");

    // generate di file (like, zig-translate-c from D-importC)
    // note: ImportC just gives no-mangling C code,
    // but does not suppress D features exception and DruntimeGC.
    // try buildD(b, .{
    //     .name = "cimport",
    //     .target = target,
    //     .optimize = optimize,
    //     .kind = .obj,
    //     .sources = &.{"src/gc.c"},
    //     .dflags = &.{
    //         "-w",
    //         "-Isrc",
    //         // zig-out/module/cimport.di
    //         b.fmt("-Hf={s}/module/cimport.di", .{b.install_path}),
    //     },
    // });

    // Unit tests
    try buildD(b, .{
        .name = "bdwgc_tests",
        .target = target,
        .optimize = optimize,
        .kind = .@"test",
        .artifact = libgc,
        .sources = &.{"src/bdwgc.d"},
        .dflags = &.{
            "-w",
            "-cov",
            "-Isrc",
        },
    });

    // Example 1
    try buildD(b, .{
        .name = "example1",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = libgc,
        .sources = &.{"examples/example1.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });

    // Example 2
    try buildD(b, .{
        .name = "example2",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = libgc,
        .sources = &.{"examples/example2.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });

    // Example 3
    try buildD(b, .{
        .name = "example3",
        .target = target,
        .optimize = optimize,
        .betterC = false, // need D runtimeGC
        .artifact = libgc,
        .sources = &.{"examples/example3.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });

    // example 4 - Mixing C++ and D code
    const libcpp = b.addStaticLibrary(.{
        .name = "example4",
        .target = target,
        .optimize = optimize,
    });
    libcpp.addCSourceFiles(.{
        .files = &.{
            "examples/example4.cc",
        },
        .flags = &.{
            "-Wall",
            "-Wpedantic",
            "-Wextra",
            "-Wpedantic",
            "-std=c++17",
        },
    });
    for (libgc.root_module.include_dirs.items) |dir| {
        libcpp.addIncludePath(dir.path);
    }
    libcpp.linkLibrary(libgccxx);
    if (libcpp.rootModuleTarget().abi != .msvc) {
        libcpp.linkLibCpp();
    } else {
        libcpp.linkLibC();
    }

    try buildD(b, .{
        .name = "example4",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = libcpp,
        .sources = &.{"examples/example4.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
            "-extern-std=c++17",
        },
    });
}
fn buildD(b: *std.Build, options: abs.DCompileStep) !void {
    const exe = try abs.ldcBuildStep(b, options);
    b.default_step.dependOn(&exe.step);
}

fn buildLibGC(b: *std.Build, options: anytype) *std.Build.Dependency {
    const enable_cplusplus = b.option(bool, "enable_cplusplus", "C++ support") orelse true;
    const build_shared_libs = b.option(bool, "BUILD_SHARED_LIBS", "Build shared libraries (otherwise static ones)") orelse false;
    const cflags_extra = b.option([]const u8, "CFLAGS_EXTRA", "Extra user-defined cflags") orelse "";
    const enable_parallel_mark = b.option(bool, "enable_parallel_mark", "Parallelize marking and free list construction") orelse true;
    const enable_thread_local_alloc = b.option(bool, "enable_thread_local_alloc", "Turn on thread-local allocation optimization") orelse true;
    const enable_threads_discovery = b.option(bool, "enable_threads_discovery", "Enable threads discovery in GC") orelse true;
    const enable_rwlock = b.option(bool, "enable_rwlock", "Enable reader mode of the allocator lock") orelse false;
    const enable_throw_bad_alloc_library = b.option(bool, "enable_throw_bad_alloc_library", "Turn on C++ gctba library build") orelse false;
    const enable_gcj_support = b.option(bool, "enable_gcj_support", "Support for gcj") orelse true;
    const enable_sigrt_signals = b.option(bool, "enable_sigrt_signals", "Use SIGRTMIN-based signals for thread suspend/resume") orelse false;
    const enable_valgrind_tracking = b.option(bool, "enable_valgrind_tracking", "Support tracking GC_malloc and friends for heap profiling tools") orelse false;
    const enable_java_finalization = b.option(bool, "enable_java_finalization", "Support for java finalization") orelse true;
    const enable_atomic_uncollectable = b.option(bool, "enable_atomic_uncollectable", "Support for atomic uncollectible allocation") orelse true;
    const enable_redirect_malloc = b.option(bool, "enable_redirect_malloc", "Redirect malloc and friend to GC routines") orelse false;
    const enable_disclaim = b.option(bool, "enable_disclaim", "Support alternative finalization interface") orelse true;
    const enable_dynamic_pointer_mask = b.option(bool, "enable_dynamic_pointer_mask", "Support pointer mask/shift set at runtime") orelse false;
    const enable_large_config = b.option(bool, "enable_large_config", "Optimize for large heap or root set") orelse false;
    const enable_gc_assertions = b.option(bool, "enable_gc_assertions", "Enable collector-internal assertion checking") orelse false;
    const enable_mmap = b.option(bool, "enable_mmap", "Use mmap instead of sbrk to expand the heap") orelse false;
    const enable_munmap = b.option(bool, "enable_munmap", "Return page to the OS if empty for N collections") orelse true;
    const enable_dynamic_loading = b.option(bool, "enable_dynamic_loading", "Enable tracing of dynamic library data roots") orelse true;
    const enable_register_main_static_data = b.option(bool, "enable_register_main_static_data", "Perform the initial guess of data root sets") orelse true;
    const enable_checksums = b.option(bool, "enable_checksums", "Report erroneously cleared dirty bits") orelse false;
    const enable_werror = b.option(bool, "enable_werror", "Pass -Werror to the C compiler (treat warnings as errors)") orelse false;
    const enable_single_obj_compilation = b.option(bool, "enable_single_obj_compilation", "Compile all libgc source files into single .o") orelse false;
    const disable_single_obj_compilation = b.option(bool, "disable_single_obj_compilation", "Compile each libgc source file independently") orelse !enable_single_obj_compilation;
    const enable_handle_fork = b.option(bool, "enable_handle_fork", "Attempt to ensure a usable collector after fork()") orelse true;
    const disable_handle_fork = b.option(bool, "disable_handle_fork", "Prohibit installation of pthread_atfork() handlers") orelse !enable_handle_fork;
    const bdwgc = b.dependency("bdwgc", .{
        .target = options[0],
        .optimize = options[1],
        // libgc configs
        .BUILD_SHARED_LIBS = build_shared_libs,
        .CFLAGS_EXTRA = cflags_extra,
        .disable_handle_fork = disable_handle_fork,
        .enable_cplusplus = enable_cplusplus,
        .enable_dynamic_loading = enable_dynamic_loading,
        .enable_register_main_static_data = enable_register_main_static_data,
        .disable_single_obj_compilation = disable_single_obj_compilation,
        .enable_throw_bad_alloc_library = enable_throw_bad_alloc_library,
        .enable_threads = is_threaded,
        .enable_thread_local_alloc = enable_thread_local_alloc,
        .enable_large_config = enable_large_config,
        .enable_munmap = enable_munmap,
        .enable_sigrt_signals = enable_sigrt_signals,
        .enable_gcj_support = enable_gcj_support,
        .enable_mmap = enable_mmap,
        .enable_java_finalization = enable_java_finalization,
        .enable_parallel_mark = enable_parallel_mark,
        .enable_redirect_malloc = enable_redirect_malloc,
        .enable_disclaim = enable_disclaim,
        .enable_atomic_uncollectable = enable_atomic_uncollectable,
        .enable_rwlock = enable_rwlock,
        .enable_gc_assertions = enable_gc_assertions,
        .enable_valgrind_tracking = enable_valgrind_tracking,
        .enable_threads_discovery = enable_threads_discovery,
        .enable_dynamic_pointer_mask = enable_dynamic_pointer_mask,
        .enable_gc_debug = (options[1] == .Debug),
        .enable_checksums = enable_checksums,
        .enable_werror = enable_werror,
    });
    return bdwgc;
}
