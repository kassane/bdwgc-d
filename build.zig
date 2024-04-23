const std = @import("std");
const abs = @import("abs");

pub fn build(b: *std.Build) !void {
    // ldc2/ldmd2 not have mingw-support
    const target = b.standardTargetOptions(.{ .default_target = if (@import("builtin").os.tag == .windows)
        try std.Target.Query.parse(.{ .arch_os_abi = "native-windows-msvc" })
    else
        .{} });
    const optimize = b.standardOptimizeOption(.{});

    const bdwgc = b.dependency("bdwgc", .{
        .target = target,
        .optimize = optimize,
        .BUILD_SHARED_LIBS = false,
        .disable_handle_fork = false,
        .enable_cplusplus = true,
        .enable_threads = true,
        .enable_thread_local_alloc = true,
        .enable_large_config = false,
        .enable_munmap = false,
        .enable_parallel_mark = false,
        .enable_redirect_malloc = false,
        .enable_rwlock = false,
        .enable_gc_assertions = true,
        .enable_gc_debug = false,
    });
    const bdwgc_artifact = bdwgc.artifact("gc");
    b.installArtifact(bdwgc_artifact);
    b.installArtifact(bdwgc.artifact("gctba"));
    b.installArtifact(bdwgc.artifact("gccpp"));

    // generate di file (like, zig-translate-c from D-importC)
    // note: ImportC just gives no-mangling C code,
    // but does not suppress D features exception and DruntimeGC.
    // try buildD(b, .{
    //     .name = "bdwgcd",
    //     .target = target,
    //     .optimize = optimize,
    //     .betterC = true, // disable D runtimeGC
    //     .kind = .obj,
    //     .artifact = bdwgc_artifact,
    //     .sources = &.{"src/gc.c"},
    //     .dflags = &.{
    //         "-w",
    //         "-Isrc",
    //         // zig-out/module/cimport.di
    //         b.fmt("-Hf={s}/module/cimport.di", .{b.install_path}),
    //     },
    // });

    try buildD(b, .{
        .name = "bdwgc_tests",
        .target = target,
        .optimize = optimize,
        .kind = .@"test",
        .artifact = bdwgc_artifact,
        .sources = &.{"src/bdwgc.d"},
        .dflags = &.{
            "-w",
            "-cov",
            "-Isrc",
        },
    });
    try buildD(b, .{
        .name = "example1",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = bdwgc_artifact,
        .sources = &.{"examples/example1.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });
    try buildD(b, .{
        .name = "example2",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = bdwgc_artifact,
        .sources = &.{"examples/example2.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });
    try buildD(b, .{
        .name = "example3",
        .target = target,
        .optimize = optimize,
        .betterC = false, // need D runtimeGC
        .artifact = bdwgc_artifact,
        .sources = &.{"examples/example3.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });

    // example - Mixing C++ and D code
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
    for (bdwgc_artifact.root_module.include_dirs.items) |dir| {
        libcpp.addIncludePath(dir.path);
    }
    libcpp.linkLibrary(bdwgc.artifact("gccpp"));
    libcpp.linkLibrary(bdwgc.artifact("gctba"));
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

    try buildD(b, .{
        .name = "example5",
        .target = target,
        .optimize = optimize,
        .betterC = false, // need D runtimeGC
        .artifact = bdwgc_artifact,
        .sources = &.{"examples/example5.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });
}
fn buildD(b: *std.Build, options: abs.DCompileStep) !void {
    const exe = try abs.ldcBuildStep(b, options);
    b.default_step.dependOn(&exe.step);
}
