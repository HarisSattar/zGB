const std = @import("std");

pub const Cartridge = struct {
    cartridge_type: u8 = undefined,
    cartridge_size: u8 = undefined,
    destination_code: u8 = undefined,
    ram_size: u8 = undefined,
    game_color_flag: u8 = undefined,
    super_game_boy_flag: u8 = undefined,

    title: []const u8 = undefined,

    rom: []u8 = undefined,

    pub fn read(self: *const Cartridge, address: u16) u8 {
        return self.rom[address];
    }

    pub fn load(self: *Cartridge, allocator: std.mem.Allocator, filename: []const u8) !void {
        const file = try std.fs.cwd().openFile(filename, .{});
        defer file.close();

        const buffer = try file.readToEndAlloc(allocator, std.math.maxInt(usize));

        self.rom = buffer;
        self.parseCartridgeHeader();
    }

    fn parseCartridgeHeader(self: *Cartridge) void {
        self.game_color_flag = self.rom[0x0143];
        self.super_game_boy_flag = self.rom[0x0146];
        self.cartridge_type = self.rom[0x0147];
        self.cartridge_size = self.rom[0x0148];
        self.ram_size = self.rom[0x0149];
        self.destination_code = self.rom[0x014A];
        self.title = self.rom[0x0134..0x0143];
    }

    pub fn deinit(self: *Cartridge, allocator: std.mem.Allocator) !void {
        allocator.free(self.rom);
    }

    pub fn format(self: Cartridge, writer: anytype) !void {
        try writer.print("Title: {s}\n", .{self.title});
        try writer.print("cartridge_type: {s}\n", .{@tagName(@as(CartridgeType, @enumFromInt(self.cartridge_type)))});
        try writer.print("cartridge_size: {s}\n", .{@tagName(@as(CartridgeSize, @enumFromInt(self.cartridge_size)))});
        try writer.print("destination_code: {s}\n", .{@tagName(@as(DestinationCode, @enumFromInt(self.destination_code)))});
        try writer.print("ram_size: {s}\n", .{@tagName(@as(RamSize, @enumFromInt(self.ram_size)))});
        try writer.print("game_color_flag: {s}\n", .{@tagName(@as(GameColorFlag, @enumFromInt(self.game_color_flag)))});
        try writer.print("super_game_boy_flag: {s}\n", .{@tagName(@as(SuperGameBoyFlag, @enumFromInt(self.super_game_boy_flag)))});
    }
};

const CartridgeType = enum(u8) { ROM_ONLY = 0x00, MBC1 = 0x01, MBC1_RAM = 0x02, MBC1_RAM_BATTERY = 0x03, MBC2 = 0x05, MBC2_BATTERY = 0x06, ROM_RAM = 0x08, ROM_RAM_BATTERY = 0x09, MMM01 = 0x0B, MMM01_RAM = 0x0C, MMM01_RAM_BATTERY = 0x0D, MBC3_TIMER_BATTERY = 0x0F, MBC3_TIMER_RAM_BATTERY = 0x10, MBC3 = 0x11, MBC3_RAM = 0x12, MBC3_RAM_BATTERY = 0x13, MBC4 = 0x15, MBC4_RAM = 0x16, MBC4_RAM_BATTERY = 0x17, MBC5 = 0x19, MBC5_RAM = 0x1A, MBC5_RAM_BATTERY = 0x1B, MBC5_RUMBLE = 0x1C, MBC5_RUMBLE_RAM_BATTERY = 0x1E, POCKET_CAMERA = 0xFC, BANDAI_TAMA5 = 0xFD, HUC3 = 0xFE, HUC1_RAM_BATTERY = 0xFF };

const CartridgeSize = enum(u8) { KB_32 = 0x00, KB_64 = 0x01, KB_128 = 0x02, KB_256 = 0x03, KB_512 = 0x04, MB_1 = 0x05, MB_2 = 0x06, MB_4 = 0x07, MB_1_1 = 0x52, MB_1_2 = 0x53, MB_1_5 = 0x54 };

const DestinationCode = enum(u8) { JAPAN = 0x00, NO_JAPAN = 0x01 };

const RamSize = enum(u8) { NONE_RAM = 0x00, KB_RAM_2 = 0x01, KB_RAM_8 = 0x02, KB_RAM_32 = 0x03 };

const GameColorFlag = enum(u8) { DMG_ONLY = 0x00, CGB_SUPPORT = 0x80, CGB_ONLY = 0xC0 };

const SuperGameBoyFlag = enum(u8) { NO_SGB = 0x00, SGB_FUNCTIONS = 0x03 };
