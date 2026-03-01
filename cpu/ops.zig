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

// ============================================================================
// Load - Immediate (LD r,n)
// ============================================================================

pub fn ld_b_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,n"});
    cpu.registers.bc.bytes.b = read_8bit(cpu, memory);
}
pub fn ld_c_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,n"});
    cpu.registers.bc.bytes.c = read_8bit(cpu, memory);
}
pub fn ld_d_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,n"});
    cpu.registers.de.bytes.d = read_8bit(cpu, memory);
}
pub fn ld_e_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,n"});
    cpu.registers.de.bytes.e = read_8bit(cpu, memory);
}
pub fn ld_h_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,n"});
    cpu.registers.hl.bytes.h = read_8bit(cpu, memory);
}
pub fn ld_l_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,n"});
    cpu.registers.hl.bytes.l = read_8bit(cpu, memory);
}
pub fn ld_a_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,n"});
    cpu.registers.af.bytes.a = read_8bit(cpu, memory);
}

// ============================================================================
// Load - 16-bit (LD rr,nn)
// ============================================================================

pub fn ld_bc_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD BC,nn"});
    cpu.registers.bc.pair = read_16bit(cpu, memory);
}
pub fn ld_de_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD DE,nn"});
    cpu.registers.de.pair = read_16bit(cpu, memory);
}
pub fn ld_hl_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD HL,nn"});
    cpu.registers.hl.pair = read_16bit(cpu, memory);
}
pub fn ld_sp_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,nn"});
    cpu.registers.sp = read_16bit(cpu, memory);
}

// ============================================================================
// Load - Register to Register (LD r,r)
// ============================================================================

// LD B,*
pub fn ld_b_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,B"});
    cpu.registers.bc.bytes.b = cpu.registers.bc.bytes.b;
}
pub fn ld_b_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,C"});
    cpu.registers.bc.bytes.b = cpu.registers.bc.bytes.c;
}
pub fn ld_b_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,D"});
    cpu.registers.bc.bytes.b = cpu.registers.de.bytes.d;
}
pub fn ld_b_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,E"});
    cpu.registers.bc.bytes.b = cpu.registers.de.bytes.e;
}
pub fn ld_b_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,H"});
    cpu.registers.bc.bytes.b = cpu.registers.hl.bytes.h;
}
pub fn ld_b_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,L"});
    cpu.registers.bc.bytes.b = cpu.registers.hl.bytes.l;
}
pub fn ld_b_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,(HL)"});
    cpu.registers.bc.bytes.b = memory.read(cpu.registers.hl.pair);
}
pub fn ld_b_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,A"});
    cpu.registers.bc.bytes.b = cpu.registers.af.bytes.a;
}

// LD C,*
pub fn ld_c_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,B"});
    cpu.registers.bc.bytes.c = cpu.registers.bc.bytes.b;
}
pub fn ld_c_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,C"});
    cpu.registers.bc.bytes.c = cpu.registers.bc.bytes.c;
}
pub fn ld_c_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,D"});
    cpu.registers.bc.bytes.c = cpu.registers.de.bytes.d;
}
pub fn ld_c_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,E"});
    cpu.registers.bc.bytes.c = cpu.registers.de.bytes.e;
}
pub fn ld_c_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,H"});
    cpu.registers.bc.bytes.c = cpu.registers.hl.bytes.h;
}
pub fn ld_c_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,L"});
    cpu.registers.bc.bytes.c = cpu.registers.hl.bytes.l;
}
pub fn ld_c_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,(HL)"});
    cpu.registers.bc.bytes.c = memory.read(cpu.registers.hl.pair);
}
pub fn ld_c_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,A"});
    cpu.registers.bc.bytes.c = cpu.registers.af.bytes.a;
}

// LD D,*
pub fn ld_d_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,B"});
    cpu.registers.de.bytes.d = cpu.registers.bc.bytes.b;
}
pub fn ld_d_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,C"});
    cpu.registers.de.bytes.d = cpu.registers.bc.bytes.c;
}
pub fn ld_d_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,D"});
    cpu.registers.de.bytes.d = cpu.registers.de.bytes.d;
}
pub fn ld_d_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,E"});
    cpu.registers.de.bytes.d = cpu.registers.de.bytes.e;
}
pub fn ld_d_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,H"});
    cpu.registers.de.bytes.d = cpu.registers.hl.bytes.h;
}
pub fn ld_d_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,L"});
    cpu.registers.de.bytes.d = cpu.registers.hl.bytes.l;
}
pub fn ld_d_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,(HL)"});
    cpu.registers.de.bytes.d = memory.read(cpu.registers.hl.pair);
}
pub fn ld_d_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,A"});
    cpu.registers.de.bytes.d = cpu.registers.af.bytes.a;
}

// LD E,*
pub fn ld_e_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,B"});
    cpu.registers.de.bytes.e = cpu.registers.bc.bytes.b;
}
pub fn ld_e_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,C"});
    cpu.registers.de.bytes.e = cpu.registers.de.bytes.e;
}
pub fn ld_e_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,D"});
    cpu.registers.de.bytes.e = cpu.registers.de.bytes.d;
}
pub fn ld_e_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,E"});
    cpu.registers.de.bytes.e = cpu.registers.de.bytes.e;
}
pub fn ld_e_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,H"});
    cpu.registers.de.bytes.e = cpu.registers.hl.bytes.h;
}
pub fn ld_e_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,L"});
    cpu.registers.de.bytes.e = cpu.registers.hl.bytes.l;
}
pub fn ld_e_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,(HL)"});
    cpu.registers.de.bytes.e = memory.read(cpu.registers.hl.pair);
}
pub fn ld_e_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,A"});
    cpu.registers.de.bytes.e = cpu.registers.af.bytes.a;
}

// LD H,*
pub fn ld_h_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,B"});
    cpu.registers.hl.bytes.h = cpu.registers.bc.bytes.b;
}
pub fn ld_h_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,C"});
    cpu.registers.hl.bytes.h = cpu.registers.bc.bytes.c;
}
pub fn ld_h_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,D"});
    cpu.registers.hl.bytes.h = cpu.registers.de.bytes.d;
}
pub fn ld_h_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,E"});
    cpu.registers.hl.bytes.h = cpu.registers.de.bytes.e;
}
pub fn ld_h_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,H"});
    cpu.registers.hl.bytes.h = cpu.registers.hl.bytes.h;
}
pub fn ld_h_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,L"});
    cpu.registers.hl.bytes.h = cpu.registers.hl.bytes.l;
}
pub fn ld_h_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,(HL)"});
    cpu.registers.hl.bytes.h = memory.read(cpu.registers.hl.pair);
}
pub fn ld_h_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,A"});
    cpu.registers.hl.bytes.h = cpu.registers.af.bytes.a;
}

// LD L,*
pub fn ld_l_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,B"});
    cpu.registers.hl.bytes.l = cpu.registers.bc.bytes.b;
}
pub fn ld_l_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,C"});
    cpu.registers.hl.bytes.l = cpu.registers.bc.bytes.c;
}
pub fn ld_l_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,D"});
    cpu.registers.hl.bytes.l = cpu.registers.de.bytes.d;
}
pub fn ld_l_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,E"});
    cpu.registers.hl.bytes.l = cpu.registers.de.bytes.e;
}
pub fn ld_l_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,H"});
    cpu.registers.hl.bytes.l = cpu.registers.hl.bytes.h;
}
pub fn ld_l_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,L"});
    cpu.registers.hl.bytes.l = cpu.registers.hl.bytes.l;
}
pub fn ld_l_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,(HL)"});
    cpu.registers.hl.bytes.l = memory.read(cpu.registers.hl.pair);
}
pub fn ld_l_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,A"});
    cpu.registers.hl.bytes.l = cpu.registers.af.bytes.a;
}

// LD A,*
pub fn ld_a_b(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,B"});
    cpu.registers.af.bytes.a = cpu.registers.bc.bytes.b;
}
pub fn ld_a_c(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,C"});
    cpu.registers.af.bytes.a = cpu.registers.bc.bytes.c;
}
pub fn ld_a_d(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,D"});
    cpu.registers.af.bytes.a = cpu.registers.de.bytes.d;
}
pub fn ld_a_e(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,E"});
    cpu.registers.af.bytes.a = cpu.registers.de.bytes.e;
}
pub fn ld_a_h(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,H"});
    cpu.registers.af.bytes.a = cpu.registers.hl.bytes.h;
}
pub fn ld_a_l(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,L"});
    cpu.registers.af.bytes.a = cpu.registers.hl.bytes.l;
}
pub fn ld_a_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
}
pub fn ld_a_a(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,A"});
    cpu.registers.af.bytes.a = cpu.registers.af.bytes.a;
}

// ============================================================================
// Load - Memory (LD (HL),r and LD r,(HL))
// ============================================================================

pub fn ld_hli_b(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),B"});
    memory.write(cpu.registers.hl.pair, cpu.registers.bc.bytes.b);
}
pub fn ld_hli_c(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),C"});
    memory.write(cpu.registers.hl.pair, cpu.registers.bc.bytes.c);
}
pub fn ld_hli_d(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),D"});
    memory.write(cpu.registers.hl.pair, cpu.registers.de.bytes.d);
}
pub fn ld_hli_e(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),E"});
    memory.write(cpu.registers.hl.pair, cpu.registers.de.bytes.e);
}
pub fn ld_hli_h(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),H"});
    memory.write(cpu.registers.hl.pair, cpu.registers.hl.bytes.h);
}
pub fn ld_hli_l(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),L"});
    memory.write(cpu.registers.hl.pair, cpu.registers.hl.bytes.l);
}
pub fn ld_hli_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
}
pub fn ld_hli_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),n"});
    memory.write(cpu.registers.hl.pair, read_8bit(cpu, memory));
}

// ============================================================================
// Load - A from/to memory (LD A,(rr) / LD (rr),A)
// ============================================================================

pub fn ld_bc_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (BC),A"});
    memory.write(cpu.registers.bc.pair, cpu.registers.af.bytes.a);
}
pub fn ld_a_bc(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(BC)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.bc.pair);
}
pub fn ld_de_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (DE),A"});
    memory.write(cpu.registers.de.pair, cpu.registers.af.bytes.a);
}
pub fn ld_a_de(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(DE)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.de.pair);
}
pub fn ldi_hl_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDI (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
    cpu.registers.hl.pair +%= 0x0001;
}
pub fn ldi_a_hl(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDI A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
    cpu.registers.hl.pair +%= 0x0001;
}
pub fn ldd_hl_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDD (HL),A"});
    memory.write(cpu.registers.hl.pair, cpu.registers.af.bytes.a);
    cpu.registers.hl.pair -%= 0x0001;
}
pub fn ldd_a_hl(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDD A,(HL)"});
    cpu.registers.af.bytes.a = memory.read(cpu.registers.hl.pair);
    cpu.registers.hl.pair -%= 0x0001;
}
pub fn ld_nn_sp(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),SP"});
    const address = read_16bit(cpu, memory);
    const sp_low: u8 = @truncate(cpu.registers.sp);
    const sp_high: u8 = @truncate(cpu.registers.sp >> 8);
    memory.write(address, sp_low);
    memory.write(address + 0x0001, sp_high);
}
pub fn ld_nn_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),A"});
    const address = read_16bit(cpu, memory);
    memory.write(address, cpu.registers.af.bytes.a);
}
pub fn ldh_nn_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDH (n),A"});
    const n: u8 = read_8bit(cpu, memory);
    const addr: u16 = IO_BASE + @as(u16, n);
    const val: u8 = cpu.registers.af.bytes.a;
    std.debug.print("LDH write addr=0x{X:0>4} n=0x{X:0>2} val=0x{X:0>2} '{c}'\n", .{ addr, n, val, val });
    memory.write(addr, val);
}
pub fn ld_ff00_c_a(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (C),A"});
    const addr: u16 = IO_BASE + @as(u16, cpu.registers.bc.bytes.c);
    const val: u8 = cpu.registers.af.bytes.a;
    std.debug.print("LD (C) write addr=0x{X:0>4} c=0x{X:0>2} val=0x{X:0>2} '{c}'\n", .{ addr, cpu.registers.bc.bytes.c, val, val });
    memory.write(addr, val);
}
pub fn ld_a_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(nn)"});
    cpu.registers.af.bytes.a = memory.read(read_16bit(cpu, memory));
}
pub fn ldh_a_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDH A,(nn)"});
    const n = read_8bit(cpu, memory);
    const addr: u16 = IO_BASE + @as(u16, n);
    const value: u8 = memory.read(addr);
    std.debug.print("LDH read addr=0x{X:0>4} n=0x{X:0>2} value=0x{X:0>2} '{c}'\n", .{ addr, n, value, value });
    cpu.registers.af.bytes.a = value;
}
pub fn ld_a_from_c(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(C)"});
    cpu.registers.af.bytes.a = memory.read(IO_BASE + cpu.registers.bc.bytes.c);
}
pub fn ld_sp_hl(cpu: *Cpu) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,HL"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"INC B"});
    cpu.registers.bc.bytes.b +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.b == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.bc.bytes.b & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_b(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC B"});
    cpu.registers.bc.bytes.b -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.b == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.bc.bytes.b & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC C"});
    cpu.registers.bc.bytes.c +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.c == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.bc.bytes.c & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC C"});
    cpu.registers.bc.bytes.c -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.bc.bytes.c == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.bc.bytes.c & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC D"});
    cpu.registers.de.bytes.d +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.d == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.de.bytes.d & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC D"});
    cpu.registers.de.bytes.d -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.d == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.de.bytes.d & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC E"});
    cpu.registers.de.bytes.e +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.e == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.de.bytes.e & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC E"});
    cpu.registers.de.bytes.e -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.de.bytes.e == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.de.bytes.e & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC H"});
    cpu.registers.hl.bytes.h +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.h == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.hl.bytes.h & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC H"});
    cpu.registers.hl.bytes.h -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.h == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.hl.bytes.h & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC L"});
    cpu.registers.hl.bytes.l +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.l == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.hl.bytes.l & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC L"});
    cpu.registers.hl.bytes.l -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.hl.bytes.l == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.hl.bytes.l & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC A"});
    cpu.registers.af.bytes.a +%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.af.bytes.a == 0) 1 else 0, .n = 0, .h = if ((cpu.registers.af.bytes.a & 0x0F) + 1 > 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn dec_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC A"});
    cpu.registers.af.bytes.a -%= 1;
    cpu.registers.af.bytes.f = .{ .z = if (cpu.registers.af.bytes.a == 0) 1 else 0, .n = 1, .h = if ((cpu.registers.af.bytes.a & 0x0F) == 0x0F) 1 else 0, .c = cpu.registers.af.bytes.f.c };
}
pub fn inc_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC (HL)"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC (HL)"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"INC BC"});
    cpu.registers.bc.pair +%= 1;
}
pub fn dec_bc(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC BC"});
    cpu.registers.bc.pair -%= 1;
}
pub fn inc_de(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC DE"});
    cpu.registers.de.pair +%= 1;
}
pub fn dec_de(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC DE"});
    cpu.registers.de.pair -%= 1;
}
pub fn inc_hl(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC HL"});
    cpu.registers.hl.pair +%= 1;
}
pub fn dec_hl(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC HL"});
    cpu.registers.hl.pair -%= 1;
}
pub fn inc_sp(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC SP"});
    cpu.registers.sp +%= 1;
}
pub fn dec_sp(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC SP"});
    cpu.registers.sp -%= 1;
}

// ============================================================================
// Add - 8-bit (ADD A,r)
// ============================================================================

pub fn add_a_b(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,B"});
    cpu.registers.af.bytes.a +%= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.bc.bytes.b & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.bc.bytes.b)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_c(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,C"});
    cpu.registers.af.bytes.a +%= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.bc.bytes.c & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.bc.bytes.c)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_d(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,D"});
    cpu.registers.af.bytes.a +%= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.de.bytes.d & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.de.bytes.d)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_e(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,E"});
    cpu.registers.af.bytes.a +%= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.de.bytes.e & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.de.bytes.e)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_h(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,H"});
    cpu.registers.af.bytes.a +%= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.hl.bytes.h & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.hl.bytes.h)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_l(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,L"});
    cpu.registers.af.bytes.a +%= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.hl.bytes.l & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.hl.bytes.l)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,(HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    cpu.registers.af.bytes.a +%= value;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, value)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_a(cpu: *Cpu, memory: *Memory) void {
    _ = memory; // Unused parameter
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,A"});
    cpu.registers.af.bytes.a +%= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (cpu.registers.af.bytes.a & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, cpu.registers.af.bytes.a)) > 0xFF) 1 else 0,
    };
}
pub fn add_a_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,n"});
    const n = read_8bit(cpu, memory);
    cpu.registers.af.bytes.a +%= n;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (n & 0x0F)) > 0x0F) 1 else 0,
        .c = if ((@as(u16, cpu.registers.af.bytes.a) + @as(u16, n)) > 0xFF) 1 else 0,
    };
}

// Add - 16-bit (ADD HL,rr)
pub fn add_hl_bc(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,BC"});
    cpu.registers.hl.pair +%= cpu.registers.bc.pair;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((cpu.registers.hl.pair & 0x0FFF) + (cpu.registers.bc.pair & 0x0FFF)) > 0x0FFF) 1 else 0,
        .c = if ((@as(u32, cpu.registers.hl.pair) + @as(u32, cpu.registers.bc.pair)) > 0xFFFF) 1 else 0,
    };
}
pub fn add_hl_de(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,DE"});
    cpu.registers.hl.pair +%= cpu.registers.de.pair;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((cpu.registers.hl.pair & 0x0FFF) + (cpu.registers.de.pair & 0x0FFF)) > 0x0FFF) 1 else 0,
        .c = if ((@as(u32, cpu.registers.hl.pair) + @as(u32, cpu.registers.de.pair)) > 0xFFFF) 1 else 0,
    };
}
pub fn add_hl_hl(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,HL"});
    cpu.registers.hl.pair +%= cpu.registers.hl.pair;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((cpu.registers.hl.pair & 0x0FFF) + (cpu.registers.hl.pair & 0x0FFF)) > 0x0FFF) 1 else 0,
        .c = if ((@as(u32, cpu.registers.hl.pair) + @as(u32, cpu.registers.hl.pair)) > 0xFFFF) 1 else 0,
    };
}
pub fn add_hl_sp(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,SP"});
    cpu.registers.hl.pair +%= cpu.registers.sp;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((cpu.registers.hl.pair & 0x0FFF) + (cpu.registers.sp & 0x0FFF)) > 0x0FFF) 1 else 0,
        .c = if ((@as(u32, cpu.registers.hl.pair) + @as(u32, cpu.registers.sp)) > 0xFFFF) 1 else 0,
    };
}
pub fn add_sp_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD SP,n"});
    const offset_i8: i8 = @bitCast(read_8bit(cpu, memory));
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    cpu.registers.sp +%= offset_u16;
    cpu.registers.af.bytes.f = .{
        .z = 0,
        .n = 0,
        .h = if (((cpu.registers.sp & 0x0FFF) + (offset_u16 & 0x0FFF)) > 0x0FFF) 1 else 0,
        .c = if ((@as(u32, cpu.registers.sp) + @as(u32, offset_u16)) > 0xFFFF) 1 else 0,
    };
}

// ============================================================================
// Add with Carry (ADC A,r)
// ============================================================================

pub fn adc_a_b(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,B"});
    const value = cpu.registers.bc.bytes.b;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,C"});
    const value = cpu.registers.bc.bytes.c;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,D"});
    const value = cpu.registers.de.bytes.d;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,E"});
    const value = cpu.registers.de.bytes.e;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,H"});
    const value = cpu.registers.hl.bytes.h;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,L"});
    const value = cpu.registers.hl.bytes.l;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,(HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,A"});
    const value = cpu.registers.af.bytes.a;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, value) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (value & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}
pub fn adc_a_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,n"});
    const n = read_8bit(cpu, memory);
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) + @as(u16, n) + @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = if (((cpu.registers.af.bytes.a & 0x0F) + (n & 0x0F) + carry) > 0x0F) 1 else 0,
        .c = if (result > 0xFF) 1 else 0,
    };
}

// ============================================================================
// Subtract (SUB r)
// ============================================================================

pub fn sub_a_b(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, B"});
    const value = cpu.registers.bc.bytes.b;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, C"});
    const value = cpu.registers.bc.bytes.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, D"});
    const value = cpu.registers.de.bytes.d;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, E"});
    const value = cpu.registers.de.bytes.e;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, H"});
    const value = cpu.registers.hl.bytes.h;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, L"});
    const value = cpu.registers.hl.bytes.l;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, (HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, A"});
    const value = cpu.registers.af.bytes.a;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sub_a_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A, n"});
    const value = read_8bit(cpu, memory);
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}

// ============================================================================
// Subtract with Carry (SBC A,r)
// ============================================================================

pub fn sbc_a_b(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,B"});
    const value = cpu.registers.bc.bytes.b;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,C"});
    const value = cpu.registers.bc.bytes.c;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,D"});
    const value = cpu.registers.de.bytes.d;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,E"});
    const value = cpu.registers.de.bytes.e;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,H"});
    const value = cpu.registers.hl.bytes.h;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,L"});
    const value = cpu.registers.hl.bytes.l;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,(HL)"});
    const value = memory.read(cpu.registers.hl.pair);
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,A"});
    const value = cpu.registers.af.bytes.a;
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}
pub fn sbc_a_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,n"});
    const value = read_8bit(cpu, memory);
    const carry = cpu.registers.af.bytes.f.c;
    const result = @as(u16, cpu.registers.af.bytes.a) - @as(u16, value) - @as(u16, carry);
    cpu.registers.af.bytes.a = @truncate(result);
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0x0F) < (value & 0x0F)) 1 else 0,
        .c = if (value > cpu.registers.af.bytes.a) 1 else 0,
    };
}

// ============================================================================
// Logical AND (AND r)
// ============================================================================

pub fn and_b(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND B"});
    cpu.registers.af.bytes.a &= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND C"});
    cpu.registers.af.bytes.a &= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND D"});
    cpu.registers.af.bytes.a &= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND E"});
    cpu.registers.af.bytes.a &= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND H"});
    cpu.registers.af.bytes.a &= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND L"});
    cpu.registers.af.bytes.a &= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND (HL)"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"AND A"});
    cpu.registers.af.bytes.a &= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 1,
        .c = 0,
    };
}
pub fn and_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND n"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR B"});
    cpu.registers.af.bytes.a ^= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR C"});
    cpu.registers.af.bytes.a ^= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR D"});
    cpu.registers.af.bytes.a ^= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR E"});
    cpu.registers.af.bytes.a ^= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR H"});
    cpu.registers.af.bytes.a ^= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR L"});
    cpu.registers.af.bytes.a ^= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR (HL)"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR A"});
    cpu.registers.af.bytes.a ^= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn xor_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR n"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"OR B"});
    cpu.registers.af.bytes.a |= cpu.registers.bc.bytes.b;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR C"});
    cpu.registers.af.bytes.a |= cpu.registers.bc.bytes.c;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR D"});
    cpu.registers.af.bytes.a |= cpu.registers.de.bytes.d;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR E"});
    cpu.registers.af.bytes.a |= cpu.registers.de.bytes.e;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR H"});
    cpu.registers.af.bytes.a |= cpu.registers.hl.bytes.h;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR L"});
    cpu.registers.af.bytes.a |= cpu.registers.hl.bytes.l;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR (HL)"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"OR A"});
    cpu.registers.af.bytes.a |= cpu.registers.af.bytes.a;
    cpu.registers.af.bytes.f = .{
        .z = if (cpu.registers.af.bytes.a == 0) 1 else 0,
        .n = 0,
        .h = 0,
        .c = 0,
    };
}
pub fn or_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR n"});
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
    std.debug.print("RUN OPCODE: {s}\n", .{"CP B"});
    const value = cpu.registers.bc.bytes.b;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_c(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP C"});
    const value = cpu.registers.bc.bytes.c;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_d(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP D"});
    const value = cpu.registers.de.bytes.d;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_e(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP E"});
    const value = cpu.registers.de.bytes.e;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_h(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP H"});
    const value = cpu.registers.hl.bytes.h;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_l(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP L"});
    const value = cpu.registers.hl.bytes.l;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_hli(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP (HL)"});
    const address = cpu.registers.hl.pair;
    const value = memory.read(address);
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_a(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP A"});
    const value = cpu.registers.af.bytes.a;
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}
pub fn cp_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP n"});
    const value = read_8bit(cpu, memory);
    const result = cpu.registers.af.bytes.a - value;
    cpu.registers.af.bytes.f = .{
        .z = if (result == 0) 1 else 0,
        .n = 1,
        .h = if ((cpu.registers.af.bytes.a & 0xF) < (value & 0xF)) 1 else 0,
        .c = if (cpu.registers.af.bytes.a < value) 1 else 0,
    };
}

// ============================================================================
// Jump (JP / JR)
// ============================================================================

pub fn jp_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP nn"});
    cpu.registers.pc = read_16bit(cpu, memory);
}
pub fn jp_nz_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP NZ,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 0) {
        cpu.registers.pc = address;
    }
}
pub fn jp_z_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP Z,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.z == 1) {
        cpu.registers.pc = address;
    }
}
pub fn jp_nc_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP NC,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 0) {
        cpu.registers.pc = address;
    }
}
pub fn jp_c_nn(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP C,nn"});
    const address = read_16bit(cpu, memory);
    if (cpu.registers.af.bytes.f.c == 1) {
        cpu.registers.pc = address;
    }
}
pub fn jp_hl(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP (HL)"});
    cpu.registers.pc = cpu.registers.hl.pair;
}

pub fn jr_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);
    cpu.registers.pc +%= offset_u16;
}
pub fn jr_nz_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR NZ,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    if (cpu.registers.af.bytes.f.z == 0) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_z_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR Z,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);
    if (cpu.registers.af.bytes.f.z == 1) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_nc_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR NC,n"});
    const offset_u8 = read_8bit(cpu, memory);
    const offset_i8: i8 = @bitCast(offset_u8); // Reinterpret bits as signed
    const offset_i16: i16 = offset_i8;
    const offset_u16: u16 = @bitCast(offset_i16);

    if (cpu.registers.af.bytes.f.c == 0) {
        cpu.registers.pc +%= offset_u16;
    }
}
pub fn jr_c_n(cpu: *Cpu, memory: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR C,n"});
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

pub fn call_nn(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL nn"});
}
pub fn call_nz_nn(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL NZ,nn"});
}
pub fn call_z_nn(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL Z,nn"});
}
pub fn call_nc_nn(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL NC,nn"});
}
pub fn call_c_nn(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL C,nn"});
}

pub fn ret(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET"});
}
pub fn ret_nz(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET NZ"});
}
pub fn ret_z(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET Z"});
}
pub fn ret_nc(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET NC"});
}
pub fn ret_c(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET C"});
}
pub fn reti(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RETI"});
}

pub fn rst_00(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 00"});
}
pub fn rst_08(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 08"});
}
pub fn rst_10(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 10"});
}
pub fn rst_18(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 18"});
}
pub fn rst_20(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 20"});
}
pub fn rst_28(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 28"});
}
pub fn rst_30(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 30"});
}
pub fn rst_38(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 38"});
}

// ============================================================================
// Push / Pop
// ============================================================================

pub fn push_bc(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH BC"});
}
pub fn push_de(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH DE"});
}
pub fn push_hl(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH HL"});
}
pub fn push_af(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH AF"});
}

pub fn pop_bc(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP BC"});
}
pub fn pop_de(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP DE"});
}
pub fn pop_hl(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP HL"});
}
pub fn pop_af(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP AF"});
}

// ============================================================================
// Rotate / Shift
// ============================================================================

pub fn rlca(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RLCA"});
}
pub fn rrca(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RRCA"});
}
pub fn rla(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RLA"});
}
pub fn rra(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RRA"});
}

// ============================================================================
// Miscellaneous
// ============================================================================

pub fn nop(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"NOP"});
}
pub fn halt(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"HALT"});
}
pub fn stop(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"STOP"});
}
pub fn di(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DI"});
    cpu.ime = false; // Disable interrupts
}
pub fn ei(cpu: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"EI"});
    cpu.ime = true; // Enable interrupts
}
pub fn daa(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DAA"});
}
pub fn cpl(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CPL"});
}
pub fn scf(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SCF"});
}
pub fn ccf(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CCF"});
}

// ============================================================================
// Prefix CB
// ============================================================================

pub fn prefix_cb(_: *Cpu, _: *Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PREFIX CB"});
}
