const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;
const Memory = @import("memory.zig").Memory;

pub const GameBoy = struct {
    cpu: Cpu = .{},
    memory: Memory = .{},

    pub fn load(self: *@This(), allocator: std.mem.Allocator, filename: []const u8) !void {
        try self.memory.load(allocator, filename);
    }

    pub fn deinit(self: *@This(), allocator: std.mem.Allocator) !void {
        try self.memory.deinit(allocator);
    }
};
