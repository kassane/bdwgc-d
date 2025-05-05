const std = @import("std");
const ldc2 = @import("abs").ldc2;
const builtin = @import("builtin");

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

    const config = optionsDefault(b, .{
        .target = target,
        .optimize = optimize,
    });
    const bdwgc = buildLibGC(b, config);
    const libgc = bdwgc.artifact("gc");
    const libcord: ?*std.Build.Step.Compile = if (config.build_cord) bdwgc.artifact("cord") else null;
    const libgctba: ?*std.Build.Step.Compile = if (config.enable_throw_bad_alloc_library) bdwgc.artifact("gctba") else null;
    const libgccxx: ?*std.Build.Step.Compile = if (config.enable_cplusplus) bdwgc.artifact("gccpp") else null;

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
    //
    //         // zig-out/module/cimport.di
    //         b.fmt("-Hf={s}/module/cimport.di", .{b.install_path}),
    //     },
    // });

    var include_dir = std.ArrayList([]const u8).init(b.allocator);
    defer include_dir.deinit();

    for (libgc.root_module.include_dirs.items) |dir| {
        include_dir.append(dir.path.getPath(b)) catch unreachable;
    }

    // Unit tests
    try buildD(b, .{
        .name = "bdwgc_tests",
        .target = target,
        .optimize = optimize,
        .kind = .@"test",
        .artifact = libgc,
        .sources = &.{"src/bdwgc.d"},
        .cIncludePaths = include_dir.items,
        .importPaths = &.{"src"},
        .dflags = &.{ "-w", "-Xcc=-std=c99", "-cov" },
    });

    if (config.build_examples) { // Example 1
        try buildD(b, .{
            .name = "example1",
            .target = target,
            .optimize = optimize,
            .betterC = true, // disable D runtimeGC
            .artifact = libgc,
            .sources = &.{"examples/example1.d"},
            .cIncludePaths = include_dir.items,
            .importPaths = &.{"src"},
            .dflags = &.{
                "-w",
                "-Xcc=-std=c99",
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
            .cIncludePaths = include_dir.items,
            .importPaths = &.{"src"},
            .dflags = &.{
                "-w",
                "-Xcc=-std=c99",
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
            .cIncludePaths = include_dir.items,
            .importPaths = &.{"src"},
            .dflags = &.{
                "-w",
                "-Xcc=-std=c99",
            },
        });

        if (libgccxx) |gccpp| {
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
                    "-std=c++17",
                },
            });
            for (libgc.root_module.include_dirs.items) |dir| {
                libcpp.addIncludePath(dir.path);
            }
            if (b.systemIntegrationOption("gccpp", .{}))
                libcpp.linkSystemLibrary("gccpp")
            else
                libcpp.linkLibrary(gccpp);
            if (libcpp.rootModuleTarget().abi != .msvc) {
                libcpp.linkLibCpp();
            } else {
                libcpp.linkLibC();
            }

            if (config.artifact_dub)
                b.installArtifact(libcpp);

            try buildD(b, .{
                .name = "example4",
                .target = target,
                .optimize = optimize,
                .betterC = true, // disable D runtimeGC
                .artifact = libcpp,
                .cIncludePaths = include_dir.items,
                .importPaths = &.{"src"},
                .sources = &.{"examples/example4.d"},
                .dflags = &.{
                    "-w",
                    "-Xcc=-std=c99",
                    "-extern-std=c++17",
                },
            });
        }
    }

    if (config.artifact_dub) {
        b.installArtifact(libgc);
        if (libgccxx) |cxx| {
            b.installArtifact(cxx);
        }
        if (libgctba) |tba| {
            b.installArtifact(tba);
        }
        if (libcord) |cord| {
            b.installArtifact(cord);
        }
    }
}
fn buildD(b: *std.Build, options: ldc2.DCompileStep) !void {
    const exe = try ldc2.BuildStep(b, options);
    b.default_step.dependOn(&exe.step);
}

fn buildLibGC(b: *std.Build, options: libGCConfig) *std.Build.Dependency {
    const bdwgc = b.dependency("bdwgc", .{
        .target = options.target,
        .optimize = options.optimize,
        .BUILD_SHARED_LIBS = options.BUILD_SHARED_LIBS,
        .CFLAGS_EXTRA = options.CFLAGS_EXTRA,
        .disable_handle_fork = options.disable_handle_fork,
        .enable_cplusplus = options.enable_cplusplus,
        .enable_dynamic_loading = options.enable_dynamic_loading,
        .enable_register_main_static_data = options.enable_register_main_static_data,
        .disable_single_obj_compilation = options.disable_single_obj_compilation,
        .enable_throw_bad_alloc_library = options.enable_throw_bad_alloc_library,
        .enable_threads = options.enable_threads,
        .enable_thread_local_alloc = options.enable_thread_local_alloc,
        .enable_large_config = options.enable_large_config,
        .enable_munmap = options.enable_munmap,
        .enable_sigrt_signals = options.enable_sigrt_signals,
        .enable_gcj_support = options.enable_gcj_support,
        .enable_mmap = options.enable_mmap,
        .enable_java_finalization = options.enable_java_finalization,
        .enable_redirect_malloc = options.enable_redirect_malloc,
        .enable_disclaim = options.enable_disclaim,
        .enable_atomic_uncollectable = options.enable_atomic_uncollectable,
        .enable_rwlock = options.enable_rwlock,
        .enable_gc_assertions = options.enable_gc_assertions,
        .enable_valgrind_tracking = options.enable_valgrind_tracking,
        .enable_threads_discovery = options.enable_threads_discovery,
        .enable_dynamic_pointer_mask = options.enable_dynamic_pointer_mask,
        .enable_gc_debug = options.enable_gc_debug,
        .enable_checksums = options.enable_checksums,
        .enable_werror = options.enable_werror,
    });
    return bdwgc;
}

fn optionsDefault(b: *std.Build, options: struct { target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode }) libGCConfig {
    const enable_cplusplus = b.option(bool, "enable_cplusplus", "C++ support") orelse true;
    const build_shared_libs = b.option(bool, "BUILD_SHARED_LIBS", "Build shared libraries (otherwise static ones)") orelse false;
    const cflags_extra = b.option([]const u8, "CFLAGS_EXTRA", "Extra user-defined cflags") orelse "";
    const enable_threads = b.option(bool, "enable_threads", "Support threads") orelse !builtin.single_threaded;
    const enable_thread_local_alloc = b.option(bool, "enable_thread_local_alloc", "Turn on thread-local allocation optimization") orelse true;
    const enable_threads_discovery = b.option(bool, "enable_threads_discovery", "Enable threads discovery in GC") orelse true;
    const enable_rwlock = b.option(bool, "enable_rwlock", "Enable reader mode of the allocator lock") orelse false;
    const enable_throw_bad_alloc_library = b.option(bool, "enable_throw_bad_alloc_library", "Turn on C++ gctba library build") orelse false;
    const enable_gcj_support = b.option(bool, "enable_gcj_support", "Support for gcj") orelse true;
    const enable_sigrt_signals = b.option(bool, "enable_sigrt_signals", "Use SIGRTMIN-based signals for thread suspend/resume") orelse false;
    const enable_valgrind_tracking = b.option(bool, "enable_valgrind_tracking", "Support tracking GC_malloc and friends for heap profiling tools") orelse false;
    const enable_java_finalization = b.option(bool, "enable_java_finalization", "Support for java finalization") orelse true;
    const enable_atomic_uncollectable = b.option(bool, "enable_atomic_uncollectable", "Support for atomic uncollectible allocation") orelse true;
    const enable_gc_debug = b.option(bool, "enable_gc_debug", "Support for pointer back-tracing") orelse (options.optimize == .Debug);
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
    const build_cord = b.option(bool, "build_cord", "Build cord library") orelse false;
    const artifact_dub = b.option(bool, "artifact_dub", "Available artifacts to DUB") orelse false;
    const build_examples = b.option(bool, "build_examples", "Build Examples") orelse true;
    return .{
        .target = options.target,
        .optimize = options.optimize,
        .artifact_dub = artifact_dub,
        .build_examples = build_examples,
        // libgc configs
        .BUILD_SHARED_LIBS = build_shared_libs,
        .CFLAGS_EXTRA = cflags_extra,
        .disable_handle_fork = disable_handle_fork,
        .enable_cplusplus = enable_cplusplus,
        .enable_dynamic_loading = enable_dynamic_loading,
        .enable_register_main_static_data = enable_register_main_static_data,
        .disable_single_obj_compilation = disable_single_obj_compilation,
        .enable_throw_bad_alloc_library = enable_throw_bad_alloc_library,
        .enable_threads = enable_threads,
        .enable_thread_local_alloc = enable_thread_local_alloc,
        .enable_large_config = enable_large_config,
        .enable_munmap = enable_munmap,
        .enable_sigrt_signals = enable_sigrt_signals,
        .enable_gcj_support = enable_gcj_support,
        .enable_mmap = enable_mmap,
        .enable_java_finalization = enable_java_finalization,
        .enable_redirect_malloc = enable_redirect_malloc,
        .enable_disclaim = enable_disclaim,
        .enable_atomic_uncollectable = enable_atomic_uncollectable,
        .enable_rwlock = enable_rwlock,
        .build_cord = build_cord,
        .enable_gc_assertions = enable_gc_assertions,
        .enable_valgrind_tracking = enable_valgrind_tracking,
        .enable_threads_discovery = enable_threads_discovery,
        .enable_dynamic_pointer_mask = enable_dynamic_pointer_mask,
        .enable_gc_debug = enable_gc_debug,
        .enable_checksums = enable_checksums,
        .enable_werror = enable_werror,
    };
}

const libGCConfig = struct {
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    BUILD_SHARED_LIBS: bool,
    CFLAGS_EXTRA: []const u8,
    disable_handle_fork: bool,
    enable_cplusplus: bool,
    enable_dynamic_loading: bool,
    enable_register_main_static_data: bool,
    disable_single_obj_compilation: bool,
    enable_throw_bad_alloc_library: bool,
    enable_threads: bool,
    enable_thread_local_alloc: bool,
    enable_large_config: bool,
    enable_munmap: bool,
    enable_sigrt_signals: bool,
    enable_gcj_support: bool,
    enable_mmap: bool,
    enable_java_finalization: bool,
    enable_redirect_malloc: bool,
    enable_disclaim: bool,
    enable_atomic_uncollectable: bool,
    enable_rwlock: bool,
    enable_gc_assertions: bool,
    enable_valgrind_tracking: bool,
    enable_threads_discovery: bool,
    enable_dynamic_pointer_mask: bool,
    enable_gc_debug: bool,
    enable_checksums: bool,
    enable_werror: bool,
    build_cord: bool,
    artifact_dub: bool,
    build_examples: bool,
};
