const std = @import("std");
const abs = @import("anotherBuildStep");

pub fn build(b: *std.Build) !void {
    // ldc2 not support mingw
    const target = b.standardTargetOptions(.{ .default_target = if (@import("builtin").os.tag == .windows)
        try std.Target.Query.parse(.{ .arch_os_abi = "native-windows-msvc" })
    else
        .{} });
    const optimize = b.standardOptimizeOption(.{});

    try buildExe(b, "example1", .{ target, optimize });
    try buildExe(b, "example2", .{ target, optimize });
}
fn buildExe(b: *std.Build, comptime name: []const u8, options: anytype) !void {
    const bdwgc = b.dependency("bdwgc", .{
        .target = options[0],
        .optimize = options[1],
        .BUILD_SHARED_LIBS = false,
    });

    const exe = try abs.ldcBuildStep(b, .{
        .name = name,
        .target = options[0],
        .optimize = options[1],
        .betterC = true, // disable D runtimeGC
        .artifact = bdwgc.artifact("gc"),
        .sources = &.{"examples/" ++ name ++ ".d"},
        .dflags = &.{
            "-w",
            "-vgc", // see Druntime GC if enabled
            "-vtls", // thread-local storage
            "-Isrc",
            b.fmt("-P-I{s}", .{bdwgc.path("include").getPath(b)}),
        },
    });
    b.default_step.dependOn(&exe.step);
}
