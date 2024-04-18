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

    // generate di file (like, zig-translate-c from D-importC)
    // note: ImportC just gives no-mangling C code,
    // but does not suppress D features exception and DruntimeGC.

    // try buildExe(b, .{
    //     .name = "bdwgcd",
    //     .target = target,
    //     .optimize = optimize,
    //     .betterC = true, // disable D runtimeGC
    //     .kind = .obj,
    //     .artifact = bdwgc.artifact("gc"),
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
        .artifact = bdwgc.artifact("gc"),
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
        .artifact = bdwgc.artifact("gc"),
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
        .artifact = bdwgc.artifact("gc"),
        .sources = &.{"examples/example3.d"},
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
