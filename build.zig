const std = @import("std");
const abs = @import("abs");

pub fn build(b: *std.Build) !void {
    // ldc2 not support mingw
    const target = b.standardTargetOptions(.{ .default_target = if (@import("builtin").os.tag == .windows)
        try std.Target.Query.parse(.{ .arch_os_abi = "native-windows-msvc" })
    else
        .{} });
    const optimize = b.standardOptimizeOption(.{});

    const bdwgc = b.dependency("bdwgc", .{
        .target = target,
        .optimize = optimize,
        .BUILD_SHARED_LIBS = false,
    });
    const bdwgc_artifact = bdwgc.artifact("gc");
    const bdwgc_path = bdwgc.path("");

    // generate di file (like, zig-translate-c from D-importC)
    // note: ImportC just gives no-mangling C code,
    // but does not suppress D features exception and DruntimeGC.
    // try buildExe(b, .{
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

    try buildExe(b, .{
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
    try buildExe(b, .{
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
    try buildExe(b, .{
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

    const lib = b.addStaticLibrary(.{
        .name = "example4",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFiles(.{
        .root = bdwgc_path,
        .files = if (lib.rootModuleTarget().abi != .msvc)
            &.{
                "gc_cpp.cc",
                "gc_badalc.cc",
            }
        else
            &.{
                "gc_cpp.cpp",
                "gc_badalc.cpp",
            },
        .flags = &.{
            "-Wall",
            "-Wpedantic",
            "-Wextra",
        },
    });
    lib.addCSourceFile(.{
        .file = b.path("examples/example4.cc"),
        .flags = &.{
            "-Wall",
            "-Wpedantic",
            "-Wextra",
        },
    });
    for (bdwgc_artifact.root_module.include_dirs.items) |dir| {
        lib.addIncludePath(dir.path);
    }
    lib.linkLibrary(bdwgc_artifact);
    if (lib.rootModuleTarget().abi != .msvc) {
        lib.linkLibCpp();
    } else {
        lib.linkLibC();
    }
    try buildExe(b, .{
        .name = "example4",
        .target = target,
        .optimize = optimize,
        .betterC = true, // need D runtimeGC
        .artifact = lib,
        .sources = &.{"examples/example4.d"},
        .dflags = &.{
            "-w",
            "-Isrc",
        },
    });
}
fn buildExe(b: *std.Build, options: abs.DCompileStep) !void {
    const exe = try abs.ldcBuildStep(b, options);
    b.default_step.dependOn(&exe.step);
}
