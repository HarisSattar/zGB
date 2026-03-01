const std = @import("std");

const Cpu = @import("cpu.zig").Cpu;
const Memory = @import("../memory.zig").Memory;

const IO_BASE: u16 = 0xFF00;

fn read_16bit(cpu: *Cpu, memory: *Memory) u16 {
    const low = memory.read(cpu.registers.pc);
    cpu.increment_pc();
    const high = memory.read(cpu.registers.pc);
    cpu.increment_pc();
    return @as(u16, high) << 8 | @as(u16, low);
}

fn read_8bit(cpu: *Cpu, memory: *Memory) u8 {
    const value = memory.read(cpu.registers.pc);
    cpu.increment_pc();
    return value;
}

fn reset_flags(cpu: *Cpu) void {
    cpu.registers.af.bytes.f.c = 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.z = 0;
}

fn stack_push_u16(cpu: *Cpu, memory: *Memory, value: u16) void {
    const high: u8 = @truncate(value >> 8);
    const low: u8 = @truncate(value);
    cpu.registers.sp -%= 1;
    memory.write(cpu.registers.sp, high);
    cpu.registers.sp -%= 1;
    memory.write(cpu.registers.sp, low);
}

fn stack_pop_u16(cpu: *Cpu, memory: *Memory) u16 {
    const low = memory.read(cpu.registers.sp);
    cpu.registers.sp +%= 1;
    const high = memory.read(cpu.registers.sp);
    cpu.registers.sp +%= 1;
    return @as(u16, high) << 8 | @as(u16, low);
}

fn add_to_a(cpu: *Cpu, value: u8, with_carry: bool) void {
    const a_before = cpu.registers.af.bytes.a;
    const carry_in: u8 = if (with_carry) cpu.registers.af.bytes.f.c else 0;
    const result16 = @as(u16, a_before) + @as(u16, value) + @as(u16, carry_in);
    const result8: u8 = @truncate(result16);
    cpu.registers.af.bytes.a = result8;
    cpu.registers.af.bytes.f = .{
        .z = if (result8 == 0) 1 else 0,
        .n = 0,
        .h = if (((a_before & 0x0F) + (value & 0x0F) + carry_in) > 0x0F) 1 else 0,
        .c = if (result16 > 0xFF) 1 else 0,
    };
}

fn sub_from_a(cpu: *Cpu, value: u8, with_carry: bool, write_back: bool) void {
    const a_before = cpu.registers.af.bytes.a;
    const carry_in: u8 = if (with_carry) cpu.registers.af.bytes.f.c else 0;
    const subtrahend = @as(u16, value) + @as(u16, carry_in);
    const result16 = @as(u16, a_before) -% subtrahend;
    const result8: u8 = @truncate(result16);

    if (write_back) {
        cpu.registers.af.bytes.a = result8;
    }

    cpu.registers.af.bytes.f = .{
        .z = if (result8 == 0) 1 else 0,
        .n = 1,
        .h = if ((a_before & 0x0F) < ((value & 0x0F) + carry_in)) 1 else 0,
        .c = if (@as(u16, a_before) < subtrahend) 1 else 0,
    };
}

fn read_cb_target(cpu: *Cpu, memory: *Memory, index: u3) u8 {
    return switch (index) {
        0 => cpu.registers.bc.bytes.b,
        1 => cpu.registers.bc.bytes.c,
        2 => cpu.registers.de.bytes.d,
        3 => cpu.registers.de.bytes.e,
        4 => cpu.registers.hl.bytes.h,
        5 => cpu.registers.hl.bytes.l,
        6 => memory.read(cpu.registers.hl.pair),
        7 => cpu.registers.af.bytes.a,
    };
}

fn write_cb_target(cpu: *Cpu, memory: *Memory, index: u3, value: u8) void {
    switch (index) {
        0 => cpu.registers.bc.bytes.b = value,
        1 => cpu.registers.bc.bytes.c = value,
        2 => cpu.registers.de.bytes.d = value,
        3 => cpu.registers.de.bytes.e = value,
        4 => cpu.registers.hl.bytes.h = value,
        5 => cpu.registers.hl.bytes.l = value,
        6 => memory.write(cpu.registers.hl.pair, value),
        7 => cpu.registers.af.bytes.a = value,
    }
}

// ============================================================================
// Load - Immediate (LD r,n)
// ============================================================================

pub fn ld_b_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,n"});
    cpu.registers.bc.bytes.b = read_8bit(cpu, memory);
}
pub fn ld_c_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,n"});
    cpu.registers.bc.bytes.c = read_8bit(cpu, memory);
}
pub fn ld_d_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,n"});
    cpu.registers.de.bytes.d = read_8bit(cpu, memory);
}
pub fn ld_e_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,n"});
    cpu.registers.de.bytes.e = read_8bit(cpu, memory);
}
pub fn ld_h_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,n"});
    cpu.registers.hl.bytes.h = read_8bit(cpu, memory);
}
pub fn ld_l_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,n"});
    cpu.registers.hl.bytes.l = read_8bit(cpu, memory);
}
pub fn ld_a_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,n"});
    cpu.registers.af.bytes.a = read_8bit(cpu, memory);
}

// ============================================================================
// Load - 16-bit (LD rr,nn)
// ============================================================================

pub fn ld_bc_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD BC,nn"});
    cpu.registers.bc.pair = read_16bit(cpu, memory);
}
pub fn ld_de_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD DE,nn"});
    cpu.registers.de.pair = read_16bit(cpu, memory);
}
pub fn ld_hl_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD HL,nn"});
    cpu.registers.hl.pair = read_16bit(cpu, memory);
}
pub fn ld_sp_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,nn"});
    cpu.registers.sp = read_16bit(cpu, memory);
}

// ============================================================================
// Load - Register to Register (LD r,r)
// ============================================================================

// LD B,*
pub fn ld_b_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,B"});
    cpu.registers.bc.bytes.b = cpu.registers.bc.bytes.b;
}
pub fn ld_b_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,C"});
    cpu.registers.bc.bytes.b = cpu.registers.bc.bytes.c;
}
pub fn ld_b_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,D"});
    cpu.registers.bc.bytes.b = cpu.registers.de.bytes.d;
}
pub fn ld_b_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,E"});
    cpu.registers.bc.bytes.b = cpu.registers.de.bytes.e;
}
pub fn ld_b_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,H"});
    cpu.registers.bc.bytes.b = cpu.registers.hl.bytes.h;
}
pub fn ld_b_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,L"});
    cpu.registers.bc.bytes.b = cpu.registers.hl.bytes.l;
}
pub fn ld_b_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,(HL)"});
    cpu.registers.bc.bytes.b = memory.read(cpu.registers.hl.pair);
}
pub fn ld_b_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD B,A"});
    cpu.registers.bc.bytes.b = cpu.registers.af.bytes.a;
}

// LD C,*
pub fn ld_c_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,B"});
    cpu.registers.bc.bytes.c = cpu.registers.bc.bytes.b;
}
pub fn ld_c_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,C"});
    cpu.registers.bc.bytes.c = cpu.registers.bc.bytes.c;
}
pub fn ld_c_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,D"});
    cpu.registers.bc.bytes.c = cpu.registers.de.bytes.d;
}
pub fn ld_c_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,E"});
    cpu.registers.bc.bytes.c = cpu.registers.de.bytes.e;
}
pub fn ld_c_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,H"});
    cpu.registers.bc.bytes.c = cpu.registers.hl.bytes.h;
}
pub fn ld_c_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,L"});
    cpu.registers.bc.bytes.c = cpu.registers.hl.bytes.l;
}
pub fn ld_c_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,(HL)"});
    cpu.registers.bc.bytes.c = memory.read(cpu.registers.hl.pair);
}
pub fn ld_c_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD C,A"});
    cpu.registers.bc.bytes.c = cpu.registers.af.bytes.a;
}

// LD D,*
pub fn ld_d_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,B"});
    cpu.registers.de.bytes.d = cpu.registers.bc.bytes.b;
}
pub fn ld_d_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,C"});
    cpu.registers.de.bytes.d = cpu.registers.bc.bytes.c;
}
pub fn ld_d_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,D"});
    cpu.registers.de.bytes.d = cpu.registers.de.bytes.d;
}
pub fn ld_d_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,E"});
    cpu.registers.de.bytes.d = cpu.registers.de.bytes.e;
}
pub fn ld_d_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,H"});
    cpu.registers.de.bytes.d = cpu.registers.hl.bytes.h;
}
pub fn ld_d_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,L"});
    cpu.registers.de.bytes.d = cpu.registers.hl.bytes.l;
}
pub fn ld_d_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,(HL)"});
    cpu.registers.de.bytes.d = memory.read(cpu.registers.hl.pair);
}
pub fn ld_d_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD D,A"});
    cpu.registers.de.bytes.d = cpu.registers.af.bytes.a;
}

// LD E,*
pub fn ld_e_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,B"});
    cpu.registers.de.bytes.e = cpu.registers.bc.bytes.b;
}
pub fn ld_e_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,C"});
    cpu.registers.de.bytes.e = cpu.registers.bc.bytes.c;
}
pub fn ld_e_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,D"});
    cpu.registers.de.bytes.e = cpu.registers.de.bytes.d;
}
pub fn ld_e_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,E"});
    cpu.registers.de.bytes.e = cpu.registers.de.bytes.e;
}
pub fn ld_e_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,H"});
    cpu.registers.de.bytes.e = cpu.registers.hl.bytes.h;
}
pub fn ld_e_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,L"});
    cpu.registers.de.bytes.e = cpu.registers.hl.bytes.l;
}
pub fn ld_e_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,(HL)"});
    cpu.registers.de.bytes.e = memory.read(cpu.registers.hl.pair);
}
pub fn ld_e_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD E,A"});
    cpu.registers.de.bytes.e = cpu.registers.af.bytes.a;
}

// LD H,*
pub fn ld_h_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,B"});
    cpu.registers.hl.bytes.h = cpu.registers.bc.bytes.b;
}
pub fn ld_h_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,C"});
    cpu.registers.hl.bytes.h = cpu.registers.bc.bytes.c;
}
pub fn ld_h_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,D"});
    cpu.registers.hl.bytes.h = cpu.registers.de.bytes.d;
}
pub fn ld_h_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,E"});
    cpu.registers.hl.bytes.h = cpu.registers.de.bytes.e;
}
pub fn ld_h_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,H"});
    cpu.registers.hl.bytes.h = cpu.registers.hl.bytes.h;
}
pub fn ld_h_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,L"});
    cpu.registers.hl.bytes.h = cpu.registers.hl.bytes.l;
}
pub fn ld_h_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,(HL)"});
    cpu.registers.hl.bytes.h = memory.read(cpu.registers.hl.pair);
}
pub fn ld_h_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD H,A"});
    cpu.registers.hl.bytes.h = cpu.registers.af.bytes.a;
}

// LD L,*
pub fn ld_l_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,B"});
    cpu.registers.hl.bytes.l = cpu.registers.bc.bytes.b;
}
pub fn ld_l_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,C"});
    cpu.registers.hl.bytes.l = cpu.registers.bc.bytes.c;
}
pub fn ld_l_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,D"});
    cpu.registers.hl.bytes.l = cpu.registers.de.bytes.d;
}
pub fn ld_l_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,E"});
    cpu.registers.hl.bytes.l = cpu.registers.de.bytes.e;
}
pub fn ld_l_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,H"});
    cpu.registers.hl.bytes.l = cpu.registers.hl.bytes.h;
}
pub fn ld_l_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,L"});
    cpu.registers.hl.bytes.l = cpu.registers.hl.bytes.l;
}
pub fn ld_l_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,(HL)"});
    cpu.registers.hl.bytes.l = memory.read(cpu.registers.hl.pair);
}
pub fn ld_l_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD L,A"});
    cpu.registers.hl.bytes.l = cpu.registers.af.bytes.a;
}

// LD A,*
pub fn ld_a_b(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,B"});
    cpu.registers.af.bytes.a = cpu.registers.bc.bytes.b;
}
pub fn ld_a_c(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,C"});
    cpu.registers.af.bytes.a = cpu.registers.bc.bytes.c;
}
pub fn ld_a_d(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,D"});
    cpu.registers.af.bytes.a = cpu.registers.de.bytes.d;
}
pub fn ld_a_e(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,E"});
    cpu.registers.af.bytes.a = cpu.registers.de.bytes.e;
}
pub fn ld_a_h(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,H"});
    cpu.registers.af.bytes.a = cpu.registers.hl.bytes.h;
}
pub fn ld_a_l(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,L"});
    cpu.registers.af.bytes.a = cpu.registers.hl.bytes.l;
}
pub fn ld_a_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
}
pub fn ld_a_a(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,A"});
    cpu.registers.af.bytes.a = cpu.registers.af.bytes.a;
}

// ============================================================================
// Load - Memory (LD (HL),r and LD r,(HL))
// ============================================================================

pub fn ld_hli_b(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),B"});
    memory.write(cpu.registers.hl.pair, cpu.registers.bc.bytes.b);
}
pub fn ld_hli_c(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),C"});
    memory.write(cpu.registers.hl.pair, cpu.registers.bc.bytes.c);
}
pub fn ld_hli_d(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),D"});
    memory.write(cpu.registers.hl.pair, cpu.registers.de.bytes.d);
}
pub fn ld_hli_e(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),E"});
    memory.write(cpu.registers.hl.pair, cpu.registers.de.bytes.e);
}
pub fn ld_hli_h(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),H"});
    memory.write(cpu.registers.hl.pair, cpu.registers.hl.bytes.h);
}
pub fn ld_hli_l(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),L"});
    memory.write(cpu.registers.hl.pair, cpu.registers.hl.bytes.l);
}
pub fn ld_hli_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
}
pub fn ld_hli_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),n"});
    memory.write(cpu.registers.hl.pair, read_8bit(cpu, memory));
}

// ============================================================================
// Load - A from/to memory (LD A,(rr) / LD (rr),A)
// ============================================================================

pub fn ld_bc_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (BC),A"});
    memory.write(cpu.registers.bc.pair, cpu.registers.af.bytes.a);
}
pub fn ld_a_bc(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(BC)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.bc.pair);
}
pub fn ld_de_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (DE),A"});
    memory.write(cpu.registers.de.pair, cpu.registers.af.bytes.a);
}
pub fn ld_a_de(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(DE)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.de.pair);
}
pub fn ldi_hl_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDI (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
    cpu.registers.hl.pair +%= 0x0001;
}
pub fn ldi_a_hl(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDI A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
    cpu.registers.hl.pair +%= 0x0001;
}
pub fn ldd_hl_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDD (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
    cpu.registers.hl.pair -%= 0x0001;
}
pub fn ldd_a_hl(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDD A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
    cpu.registers.hl.pair -%= 0x0001;
}
pub fn ld_nn_sp(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),SP"});
    const address = read_16bit(cpu, memory);
    const sp_low: u8 = @truncate(cpu.registers.sp);
    const sp_high: u8 = @truncate(cpu.registers.sp >> 8);
    memory.write(address, sp_low);
    memory.write(address + 0x0001, sp_high);
}
pub fn ld_nn_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),A"});
    const address = read_16bit(cpu, memory);
    memory.write(address, cpu.registers.af.bytes.a);
}
pub fn ldh_nn_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDH (n),A"});
    const n: u8 = read_8bit(cpu, memory);
    const addr: u16 = IO_BASE + @as(u16, n);
    const val: u8 = cpu.registers.af.bytes.a;
    memory.write(addr, val);
}
pub fn ld_ff00_c_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD (C),A"});
    const addr: u16 = IO_BASE + @as(u16, cpu.registers.bc.bytes.c);
    const val: u8 = cpu.registers.af.bytes.a;
    memory.write(addr, val);
}
pub fn ld_a_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(nn)"});
    cpu.registers.af.bytes.a = memory.read(read_16bit(cpu, memory));
}
pub fn ldh_a_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LDH A,(nn)"});
    const n = read_8bit(cpu, memory);
    const addr: u16 = IO_BASE + @as(u16, n);
    const value: u8 = memory.read(addr);
    cpu.registers.af.bytes.a = value;
}
pub fn ld_a_from_c(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(C)"});
    cpu.registers.af.bytes.a = memory.read(IO_BASE + cpu.registers.bc.bytes.c);
}
pub fn ld_sp_hl(cpu: *Cpu) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,HL"});
    cpu.registers.sp = cpu.registers.hl.pair;
}
pub fn ld_hl_sp_n(cpu: *Cpu, memory: *Memory) void {
    const sp_low: u8 = @truncate(cpu.registers.sp);
    const offset_u8 = read_8bit(cpu, memory); // Keep as u8
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed

    // Sign-extend to 16 bits for the full addition
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    const result = cpu.registers.sp +% offset_u16;

    // H flag: carry from bit 3 of the lower byte addition
    const h = ((sp_low & 0x0F) + (offset_u8 & 0x0F)) > 0x0F;

    // C flag: carry from bit 7
    const c = (@as(u16, sp_low) + @as(u16, offset_u8)) > 0xFF;
    reset_flags(cpu);
    if (h) cpu.registers.af.bytes.f.h = 1;
    if (c) cpu.registers.af.bytes.f.c = 1;
    cpu.registers.hl.pair = result;
}

// ============================================================================
// Increment/Decrement - 8-bit (INC r / DEC r)
// ============================================================================

pub fn inc_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC B"});
    cpu.registers.bc.bytes.b +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.b == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.bc.bytes.b & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC B"});
    cpu.registers.bc.bytes.b -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.b == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.bc.bytes.b & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC C"});
    cpu.registers.bc.bytes.c +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.c == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.bc.bytes.c & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC C"});
    cpu.registers.bc.bytes.c -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.c == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.bc.bytes.c & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC D"});
    cpu.registers.de.bytes.d +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.d == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.de.bytes.d & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC D"});
    cpu.registers.de.bytes.d -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.d == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.de.bytes.d & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC E"});
    cpu.registers.de.bytes.e +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.e == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.de.bytes.e & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC E"});
    cpu.registers.de.bytes.e -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.e == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.de.bytes.e & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC H"});
    cpu.registers.hl.bytes.h +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.h == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.hl.bytes.h & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC H"});
    cpu.registers.hl.bytes.h -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.h == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.hl.bytes.h & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC L"});
    cpu.registers.hl.bytes.l +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.l == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.hl.bytes.l & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC L"});
    cpu.registers.hl.bytes.l -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.l == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.hl.bytes.l & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC A"});
    cpu.registers.af.bytes.a +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.af.bytes.a == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.af.bytes.a & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC A"});
    cpu.registers.af.bytes.a -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.af.bytes.a == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.af.bytes.a & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC (HL)"});
    const hl = cpu.registers.hl.pair;
    const value = memory.read(hl);
    memory.write(hl, value + 1);
    cpu.registers.af.bytes.f = .{
        .z = if (value + 1 == 0) 1 else 0,
        .n = 0,
        .h = if ((value & 0x0F) + 1 > 0x0F) 1 else 0,
        .c = cpu.registers.af.bytes.f.c,
    };
}
pub fn dec_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC (HL)"});
    const hl = cpu.registers.hl.pair;
    const value = memory.read(hl);
    memory.write(hl, value - 1);
    cpu.registers.af.bytes.f = .{
        .z = if (value - 1 == 0) 1 else 0,
        .n = 1,
        .h = if ((value & 0x0F) == 0x00) 1 else 0,
        .c = cpu.registers.af.bytes.f.c,
    };
}

// ============================================================================
// Increment/Decrement - 16-bit (INC rr / DEC rr)
// ============================================================================

pub fn inc_bc(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC BC"});
    cpu.registers.bc.pair +%= 1;
}
pub fn dec_bc(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC BC"});
    cpu.registers.bc.pair -%= 1;
}
pub fn inc_de(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC DE"});
    cpu.registers.de.pair +%= 1;
}
pub fn dec_de(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC DE"});
    cpu.registers.de.pair -%= 1;
}
pub fn inc_hl(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC HL"});
    cpu.registers.hl.pair +%= 1;
}
pub fn dec_hl(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC HL"});
    cpu.registers.hl.pair -%= 1;
}
pub fn inc_sp(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"INC SP"});
    cpu.registers.sp +%= 1;
}
pub fn dec_sp(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DEC SP"});
    cpu.registers.sp -%= 1;
}

// ============================================================================
// Add - 8-bit (ADD A,r)
// ============================================================================

pub fn add_a_b(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,B"});
    _ = memory;
    add_to_a(cpu, cpu.registers.bc.bytes.b, false);
}
pub fn add_a_c(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,C"});
    _ = memory;
    add_to_a(cpu, cpu.registers.bc.bytes.c, false);
}
pub fn add_a_d(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,D"});
    _ = memory;
    add_to_a(cpu, cpu.registers.de.bytes.d, false);
}
pub fn add_a_e(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,E"});
    _ = memory;
    add_to_a(cpu, cpu.registers.de.bytes.e, false);
}
pub fn add_a_h(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,H"});
    _ = memory;
    add_to_a(cpu, cpu.registers.hl.bytes.h, false);
}
pub fn add_a_l(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,L"});
    _ = memory;
    add_to_a(cpu, cpu.registers.hl.bytes.l, false);
}
pub fn add_a_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,(HL)"});
    add_to_a(cpu, memory.read(cpu.registers.hl.pair), false);
}
pub fn add_a_a(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,A"});
    _ = memory;
    add_to_a(cpu, cpu.registers.af.bytes.a, false);
}
pub fn add_a_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,n"});
    add_to_a(cpu, read_8bit(cpu, memory), false);
}

// Add - 16-bit (ADD HL,rr)
pub fn add_hl_bc(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,BC"});
    const hl = cpu.registers.hl.pair;
    const value = cpu.registers.bc.pair;
    cpu.registers.hl.pair +%= value;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = if (((hl & 0x0FFF) + (value & 0x0FFF)) > 0x0FFF) 1 else 0;
    cpu.registers.af.bytes.f.c = if ((@as(u32, hl) + @as(u32, value)) > 0xFFFF) 1 else 0;
}
pub fn add_hl_de(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,DE"});
    const hl = cpu.registers.hl.pair;
    const value = cpu.registers.de.pair;
    cpu.registers.hl.pair +%= value;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = if (((hl & 0x0FFF) + (value & 0x0FFF)) > 0x0FFF) 1 else 0;
    cpu.registers.af.bytes.f.c = if ((@as(u32, hl) + @as(u32, value)) > 0xFFFF) 1 else 0;
}
pub fn add_hl_hl(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,HL"});
    const hl = cpu.registers.hl.pair;
    cpu.registers.hl.pair +%= hl;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = if (((hl & 0x0FFF) + (hl & 0x0FFF)) > 0x0FFF) 1 else 0;
    cpu.registers.af.bytes.f.c = if ((@as(u32, hl) + @as(u32, hl)) > 0xFFFF) 1 else 0;
}
pub fn add_hl_sp(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,SP"});
    const hl = cpu.registers.hl.pair;
    const value = cpu.registers.sp;
    cpu.registers.hl.pair +%= value;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = if (((hl & 0x0FFF) + (value & 0x0FFF)) > 0x0FFF) 1 else 0;
    cpu.registers.af.bytes.f.c = if ((@as(u32, hl) + @as(u32, value)) > 0xFFFF) 1 else 0;
}
pub fn add_sp_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADD SP,n"});
    const sp = cpu.registers.sp;
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8);
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    cpu.registers.sp +%= offset_u16;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((sp & 0x000F) + (@as(u16, offset_u8) & 0x000F)) > 0x000F) 1 else 0,
        .c = if (((sp & 0x00FF) + (@as(u16, offset_u8) & 0x00FF)) > 0x00FF) 1 else 0,
    };
}

// ============================================================================
// Add with Carry (ADC A,r)
// ============================================================================

pub fn adc_a_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,B"});
    add_to_a(cpu, cpu.registers.bc.bytes.b, true);
}
pub fn adc_a_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,C"});
    add_to_a(cpu, cpu.registers.bc.bytes.c, true);
}
pub fn adc_a_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,D"});
    add_to_a(cpu, cpu.registers.de.bytes.d, true);
}
pub fn adc_a_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,E"});
    add_to_a(cpu, cpu.registers.de.bytes.e, true);
}
pub fn adc_a_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,H"});
    add_to_a(cpu, cpu.registers.hl.bytes.h, true);
}
pub fn adc_a_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,L"});
    add_to_a(cpu, cpu.registers.hl.bytes.l, true);
}
pub fn adc_a_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,(HL)"});
    add_to_a(cpu, memory.read(cpu.registers.hl.pair), true);
}
pub fn adc_a_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,A"});
    add_to_a(cpu, cpu.registers.af.bytes.a, true);
}
pub fn adc_a_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,n"});
    add_to_a(cpu, read_8bit(cpu, memory), true);
}

// ============================================================================
// Subtract (SUB r)
// ============================================================================

pub fn sub_a_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, B"});
    sub_from_a(cpu, cpu.registers.bc.bytes.b, false, true);
}
pub fn sub_a_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, C"});
    sub_from_a(cpu, cpu.registers.bc.bytes.c, false, true);
}
pub fn sub_a_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, D"});
    sub_from_a(cpu, cpu.registers.de.bytes.d, false, true);
}
pub fn sub_a_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, E"});
    sub_from_a(cpu, cpu.registers.de.bytes.e, false, true);
}
pub fn sub_a_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, H"});
    sub_from_a(cpu, cpu.registers.hl.bytes.h, false, true);
}
pub fn sub_a_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, L"});
    sub_from_a(cpu, cpu.registers.hl.bytes.l, false, true);
}
pub fn sub_a_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, (HL)"});
    sub_from_a(cpu, memory.read(cpu.registers.hl.pair), false, true);
}
pub fn sub_a_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, A"});
    sub_from_a(cpu, cpu.registers.af.bytes.a, false, true);
}
pub fn sub_a_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, n"});
    sub_from_a(cpu, read_8bit(cpu, memory), false, true);
}

// ============================================================================
// Subtract with Carry (SBC A,r)
// ============================================================================

pub fn sbc_a_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,B"});
    sub_from_a(cpu, cpu.registers.bc.bytes.b, true, true);
}
pub fn sbc_a_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,C"});
    sub_from_a(cpu, cpu.registers.bc.bytes.c, true, true);
}
pub fn sbc_a_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,D"});
    sub_from_a(cpu, cpu.registers.de.bytes.d, true, true);
}
pub fn sbc_a_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,E"});
    sub_from_a(cpu, cpu.registers.de.bytes.e, true, true);
}
pub fn sbc_a_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,H"});
    sub_from_a(cpu, cpu.registers.hl.bytes.h, true, true);
}
pub fn sbc_a_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,L"});
    sub_from_a(cpu, cpu.registers.hl.bytes.l, true, true);
}
pub fn sbc_a_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,(HL)"});
    sub_from_a(cpu, memory.read(cpu.registers.hl.pair), true, true);
}
pub fn sbc_a_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,A"});
    sub_from_a(cpu, cpu.registers.af.bytes.a, true, true);
}
pub fn sbc_a_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,n"});
    sub_from_a(cpu, read_8bit(cpu, memory), true, true);
}

// ============================================================================
// Logical AND (AND r)
// ============================================================================

pub fn and_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND B"});
    cpu.registers.af.bytes.a &= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND C"});
    cpu.registers.af.bytes.a &= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND D"});
    cpu.registers.af.bytes.a &= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND E"});
    cpu.registers.af.bytes.a &= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND H"});
    cpu.registers.af.bytes.a &= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND L"});
    cpu.registers.af.bytes.a &= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND (HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    cpu.registers.af.bytes.a &= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND A"});
    cpu.registers.af.bytes.a &= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"AND n"});
    const value = read_8bit(cpu, memory);
    cpu.registers.af.bytes.a &= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}

// ============================================================================
// Logical XOR (XOR r)
// ============================================================================

pub fn xor_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR B"});
    cpu.registers.af.bytes.a ^= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR C"});
    cpu.registers.af.bytes.a ^= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR D"});
    cpu.registers.af.bytes.a ^= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR E"});
    cpu.registers.af.bytes.a ^= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR H"});
    cpu.registers.af.bytes.a ^= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR L"});
    cpu.registers.af.bytes.a ^= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR (HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    cpu.registers.af.bytes.a ^= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR A"});
    cpu.registers.af.bytes.a ^= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"XOR n"});
    const value = read_8bit(cpu, memory);
    cpu.registers.af.bytes.a ^= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}

// ============================================================================
// Logical OR (OR r)
// ============================================================================

pub fn or_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR B"});
    cpu.registers.af.bytes.a |= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR C"});
    cpu.registers.af.bytes.a |= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR D"});
    cpu.registers.af.bytes.a |= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR E"});
    cpu.registers.af.bytes.a |= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR H"});
    cpu.registers.af.bytes.a |= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR L"});
    cpu.registers.af.bytes.a |= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR (HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    cpu.registers.af.bytes.a |= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR A"});
    cpu.registers.af.bytes.a |= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"OR n"});
    const value = read_8bit(cpu, memory);
    cpu.registers.af.bytes.a |= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}

// ============================================================================
// Compare (CP r)
// ============================================================================

pub fn cp_b(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP B"});
    sub_from_a(cpu, cpu.registers.bc.bytes.b, false, false);
}
pub fn cp_c(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP C"});
    sub_from_a(cpu, cpu.registers.bc.bytes.c, false, false);
}
pub fn cp_d(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP D"});
    sub_from_a(cpu, cpu.registers.de.bytes.d, false, false);
}
pub fn cp_e(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP E"});
    sub_from_a(cpu, cpu.registers.de.bytes.e, false, false);
}
pub fn cp_h(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP H"});
    sub_from_a(cpu, cpu.registers.hl.bytes.h, false, false);
}
pub fn cp_l(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP L"});
    sub_from_a(cpu, cpu.registers.hl.bytes.l, false, false);
}
pub fn cp_hli(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP (HL)"});
    sub_from_a(cpu, memory.read(cpu.registers.hl.pair), false, false);
}
pub fn cp_a(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP A"});
    sub_from_a(cpu, cpu.registers.af.bytes.a, false, false);
}
pub fn cp_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CP n"});
    sub_from_a(cpu, read_8bit(cpu, memory), false, false);
}

// ============================================================================
// Jump (JP / JR)
// ============================================================================

pub fn jp_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP nn"});
    cpu.registers.pc = read_16bit(cpu, memory);
}
pub fn jp_nz_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP NZ,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 0) {
        cpu.registers.pc = address;
    }
}
pub fn jp_z_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP Z,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 1) {
        cpu.registers.pc = address;
    }
}
pub fn jp_nc_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP NC,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 0) {
        cpu.registers.pc = address;
    }
}
pub fn jp_c_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP C,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 1) {
        cpu.registers.pc = address;
    }
}
pub fn jp_hl(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JP (HL)"});
    cpu.registers.pc = cpu.registers.hl.pair;
}

pub fn jr_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JR n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);
    cpu.registers.pc +%= offset_u16;
}
pub fn jr_nz_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JR NZ,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    if (cpu.registers.af.bytes.f.z == 0) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_z_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JR Z,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);
    if (cpu.registers.af.bytes.f.z == 1) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_nc_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JR NC,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    if (cpu.registers.af.bytes.f.c == 0) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_c_n(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"JR C,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    if (cpu.registers.af.bytes.f.c == 1) {
        cpu.registers.pc +%= offset_u16;
    }
}

// ============================================================================
// Call / Return / Restart
// ============================================================================

pub fn call_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CALL nn"});
    const address = read_16bit(cpu, memory);
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = address;
}
pub fn call_nz_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CALL NZ,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 0) {
        stack_push_u16(cpu, memory, cpu.registers.pc);
        cpu.registers.pc = address;
    }
}
pub fn call_z_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CALL Z,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 1) {
        stack_push_u16(cpu, memory, cpu.registers.pc);
        cpu.registers.pc = address;
    }
}
pub fn call_nc_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CALL NC,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 0) {
        stack_push_u16(cpu, memory, cpu.registers.pc);
        cpu.registers.pc = address;
    }
}
pub fn call_c_nn(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CALL C,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 1) {
        stack_push_u16(cpu, memory, cpu.registers.pc);
        cpu.registers.pc = address;
    }
}

pub fn ret(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RET"});
    cpu.registers.pc = stack_pop_u16(cpu, memory);
}
pub fn ret_nz(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RET NZ"});
    if (cpu.registers.af.bytes.f.z == 0) {
        ret(cpu, memory);
    }
}
pub fn ret_z(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RET Z"});
    if (cpu.registers.af.bytes.f.z == 1) {
        ret(cpu, memory);
    }
}
pub fn ret_nc(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RET NC"});
    if (cpu.registers.af.bytes.f.c == 0) {
        ret(cpu, memory);
    }
}
pub fn ret_c(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RET C"});
    if (cpu.registers.af.bytes.f.c == 1) {
        ret(cpu, memory);
    }
}
pub fn reti(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RETI"});
    ret(cpu, memory);
    cpu.ime = true;
    cpu.ime_enable_pending = false;
}

pub fn rst_00(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 00"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0000;
}
pub fn rst_08(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 08"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0008;
}
pub fn rst_10(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 10"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0010;
}
pub fn rst_18(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 18"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0018;
}
pub fn rst_20(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 20"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0020;
}
pub fn rst_28(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 28"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0028;
}
pub fn rst_30(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 30"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0030;
}
pub fn rst_38(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RST 38"});
    stack_push_u16(cpu, memory, cpu.registers.pc);
    cpu.registers.pc = 0x0038;
}

// ============================================================================
// Push / Pop
// ============================================================================

pub fn push_bc(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"PUSH BC"});
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.bc.bytes.b);
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.bc.bytes.c);
}
pub fn push_de(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"PUSH DE"});
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.de.bytes.d);
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.de.bytes.e);
}
pub fn push_hl(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"PUSH HL"});
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.hl.bytes.h);
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.hl.bytes.l);
}
pub fn push_af(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"PUSH AF"});
    dec_sp(cpu, memory);
    memory.write(cpu.registers.sp, cpu.registers.af.bytes.a);
    dec_sp(cpu, memory);
    const value: u8 = @truncate(@as(u8, cpu.registers.af.bytes.f.z) << 0x7 |
        @as(u8, cpu.registers.af.bytes.f.n) << 6 |
        @as(u8, cpu.registers.af.bytes.f.h) << 5 |
        @as(u8, cpu.registers.af.bytes.f.c) << 4);
    memory.write(cpu.registers.sp, value);
}

pub fn pop_bc(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"POP BC"});
    cpu.registers.bc.bytes.c = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
    cpu.registers.bc.bytes.b = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
}
pub fn pop_de(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"POP DE"});
    cpu.registers.de.bytes.e = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
    cpu.registers.de.bytes.d = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
}
pub fn pop_hl(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"POP HL"});
    cpu.registers.hl.bytes.l = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
    cpu.registers.hl.bytes.h = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
}
pub fn pop_af(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"POP AF"});
    cpu.registers.af.bytes.f = .{
        .z = @truncate((memory.read(cpu.registers.sp) >> 7) & 1),
        .n = @truncate((memory.read(cpu.registers.sp) >> 6) & 1),
        .h = @truncate((memory.read(cpu.registers.sp) >> 5) & 1),
        .c = @truncate((memory.read(cpu.registers.sp) >> 4) & 1),
    };
    inc_sp(cpu, memory);
    cpu.registers.af.bytes.a = memory.read(cpu.registers.sp);
    inc_sp(cpu, memory);
}

// ============================================================================
// Rotate / Shift
// ============================================================================

pub fn rlca(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RLCA"});
    const carry: u8 = (cpu.registers.af.bytes.a >> 7) & 1;
    cpu.registers.af.bytes.a = (cpu.registers.af.bytes.a << 1) | carry;
    cpu.registers.af.bytes.f.z = 0;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.c = @truncate(carry);
}
pub fn rrca(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RRCA"});
    const carry: u8 = cpu.registers.af.bytes.a & 1;
    cpu.registers.af.bytes.a = (cpu.registers.af.bytes.a >> 1) | (carry << 7);
    cpu.registers.af.bytes.f.z = 0;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.c = @truncate(carry);
}
pub fn rla(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RLA"});
    const temp = cpu.registers.af.bytes.f.c;
    cpu.registers.af.bytes.f.c = @truncate((cpu.registers.af.bytes.a >> 7) & 1);
    cpu.registers.af.bytes.a <<= 1;
    cpu.registers.af.bytes.a |= temp;
    cpu.registers.af.bytes.f.z = 0;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
}
pub fn rra(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"RRA"});
    const temp = @as(u8, cpu.registers.af.bytes.f.c) << 7;
    cpu.registers.af.bytes.f.c = @truncate(cpu.registers.af.bytes.a & 1);
    cpu.registers.af.bytes.a >>= 1;
    cpu.registers.af.bytes.a |= temp;
    cpu.registers.af.bytes.f.z = 0;
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
}

// ============================================================================
// Miscellaneous
// ============================================================================

pub fn nop(_: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"NOP"});
}
pub fn halt(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"HALT"});
    cpu.halted = true;
}
pub fn stop(_: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"STOP"});
}
pub fn di(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DI"});
    cpu.ime = false; // Disable interrupts
}
pub fn ei(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"EI"});
    cpu.ime_enable_pending = true;
}
pub fn daa(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"DAA"});
    var correction: u8 = 0;
    var set_carry = cpu.registers.af.bytes.f.c == 1;
    const subtract = cpu.registers.af.bytes.f.n == 1;

    if (!subtract) {
        if (cpu.registers.af.bytes.f.h == 1 or (cpu.registers.af.bytes.a & 0x0F) > 0x09) {
            correction |= 0x06;
        }
        if (cpu.registers.af.bytes.f.c == 1 or cpu.registers.af.bytes.a > 0x99) {
            correction |= 0x60;
            set_carry = true;
        }
        cpu.registers.af.bytes.a +%= correction;
    } else {
        if (cpu.registers.af.bytes.f.h == 1) {
            correction |= 0x06;
        }
        if (cpu.registers.af.bytes.f.c == 1) {
            correction |= 0x60;
        }
        cpu.registers.af.bytes.a -%= correction;
    }

    cpu.registers.af.bytes.f.z = if (cpu.registers.af.bytes.a == 0) 1 else 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.c = if (set_carry) 1 else 0;
}
pub fn cpl(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CPL"});
    cpu.registers.af.bytes.a = ~cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f.n = 1;
    cpu.registers.af.bytes.f.h = 1;
}
pub fn scf(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"SCF"});
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.c = 1;
}
pub fn ccf(cpu: *Cpu, _: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"CCF"});
    cpu.registers.af.bytes.f.n = 0;
    cpu.registers.af.bytes.f.h = 0;
    cpu.registers.af.bytes.f.c = ~cpu.registers.af.bytes.f.c;
}

// ============================================================================
// Prefix CB
// ============================================================================

pub fn prefix_cb(cpu: *Cpu, memory: *Memory) void {
    // std.debug.print("RUN OPCODE: {s}\n", .{"PREFIX CB"});
    const opcode = read_8bit(cpu, memory);
    const x: u2 = @truncate(opcode >> 6);
    const y: u3 = @truncate((opcode >> 3) & 0x07);
    const z: u3 = @truncate(opcode & 0x07);

    var value = read_cb_target(cpu, memory, z);

    switch (x) {
        0 => {
            var carry_out: u1 = 0;
            switch (y) {
                0 => {
                    carry_out = @truncate((value >> 7) & 1);
                    value = (value << 1) | @as(u8, carry_out);
                },
                1 => {
                    carry_out = @truncate(value & 1);
                    value = (value >> 1) | (@as(u8, carry_out) << 7);
                },
                2 => {
                    const carry_in: u8 = cpu.registers.af.bytes.f.c;
                    carry_out = @truncate((value >> 7) & 1);
                    value = (value << 1) | carry_in;
                },
                3 => {
                    const carry_in: u8 = cpu.registers.af.bytes.f.c;
                    carry_out = @truncate(value & 1);
                    value = (value >> 1) | (carry_in << 7);
                },
                4 => {
                    carry_out = @truncate((value >> 7) & 1);
                    value <<= 1;
                },
                5 => {
                    carry_out = @truncate(value & 1);
                    value = (value >> 1) | (value & 0x80);
                },
                6 => {
                    carry_out = 0;
                    value = (value << 4) | (value >> 4);
                },
                7 => {
                    carry_out = @truncate(value & 1);
                    value >>= 1;
                },
            }

            write_cb_target(cpu, memory, z, value);
            cpu.registers.af.bytes.f.z = if (value == 0) 1 else 0;
            cpu.registers.af.bytes.f.n = 0;
            cpu.registers.af.bytes.f.h = 0;
            cpu.registers.af.bytes.f.c = carry_out;
        },
        1 => {
            const mask: u8 = @as(u8, 1) << y;
            cpu.registers.af.bytes.f.z = if ((value & mask) == 0) 1 else 0;
            cpu.registers.af.bytes.f.n = 0;
            cpu.registers.af.bytes.f.h = 1;
        },
        2 => {
            value &= ~(@as(u8, 1) << y);
            write_cb_target(cpu, memory, z, value);
        },
        3 => {
            value |= @as(u8, 1) << y;
            write_cb_target(cpu, memory, z, value);
        },
    }
}
