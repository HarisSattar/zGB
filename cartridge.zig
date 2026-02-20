pub const Cartridge = struct {
    cartridge_type: u8 = undefined,
    rom: []const u8,

    pub fn read(self: *const @This(), address: u8) u8 {
        return self.rom[address];
    }
};
