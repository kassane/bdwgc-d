const std = @import("std");
const abs = @import("anotherBuildStep");

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
    const exe = try abs.ldcBuildStep(b, .{
        .name = "example1",
        .target = target,
        .optimize = optimize,
        .betterC = true, // disable D runtimeGC
        .artifact = bdwgc.artifact("gc"),
        .sources = &.{"examples/example1.d"},
        .dflags = &.{
            "-w",
            "-vgc",
            "-Isrc",
            b.fmt("-P-I{s}", .{bdwgc.path("include").getPath(b)}),
        },
    });
    b.default_step.dependOn(&exe.step);
}
