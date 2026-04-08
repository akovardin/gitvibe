const std = @import("std");
const gitvibe = @import("gitvibe");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    try gitvibe.bufferedPrint();

    const git = @cImport({
        @cInclude("git2.h");
    });

    _ = git.git_libgit2_init();

    var out: ?*git.git_repository = null;

    const res = git.git_repository_open(@ptrCast(&out), "/Users/artem/projects/gitvibe");

    std.debug.print("Repository open result: {d}\n", .{res});

    if (res == 0) {
        if (out) |repo| {
            std.debug.print("Repository opened successfully!\n", .{});
            git.git_repository_free(repo);
        }
    } else {
        std.debug.print("Failed to open repository. Error code: {d}\n", .{res});
    }

    _ = git.git_libgit2_shutdown();
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
