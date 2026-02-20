const Cpu = @import("cpu.zig").Cpu;
const Memory = @import("memory.zig").Memory;

pub const GameBoy = struct {
    cpu: Cpu = .{},
    memory: Memory = .{},
};
