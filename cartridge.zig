const std = @import("std");

pub const Cartridge = struct {
    cartridge_type: u8 = undefined,
    rom: []u8 = undefined,

    pub fn read(self: *const @This(), address: u16) u8 {
        return self.rom[address];
    }

    pub fn load(self: *@This(), allocator: std.mem.Allocator, filename: []const u8) !void {
        const file = try std.fs.cwd().openFile(filename, .{});
        defer file.close();

        const buffer = try file.readToEndAlloc(allocator, std.math.maxInt(usize));

        self.rom = buffer;

        std.debug.print("ROM Size: {d} bytes\n", .{self.rom.len});

        // 2. Print first 16 bytes in Hex
        const preview_len = @min(self.rom.len, 16);
        std.debug.print("First 16 bytes: {x}\n", .{self.rom[0..preview_len]});
        // 3. GameBoy specific: The Title starts at 0x0134
        if (self.rom.len >= 0x0143) {
            const title = self.rom[0x0134..0x0143];
            std.debug.print("ROM Title: {s}\n", .{title});
        }
    }

    pub fn deinit(self: *Cartridge, allocator: std.mem.Allocator) !void {
        allocator.free(self.rom);
    }
};
