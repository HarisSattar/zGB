const std = @import("std");

const Cpu = @import("cpu.zig").Cpu;
const Memory = @import("../memory.zig").Memory;

pub const Opcode = fn (*Cpu, *const Memory) void;

pub fn nop(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"NOP"});
}
pub fn ld_bc_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD BC,nn"});
}
pub fn ld_bc_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (BC),A"});
}
pub fn inc_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC BC"});
}
pub fn inc_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC B"});
}
pub fn dec_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC B"});
}
pub fn ld_b_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,n"});
}
pub fn rlca(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RLCA"});
}
pub fn ld_nn_sp(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),SP"});
}
pub fn add_hl_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,BC"});
}
pub fn ld_a_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(BC)"});
}
pub fn dec_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC BC"});
}
pub fn inc_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC C"});
}
pub fn dec_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC C"});
}
pub fn ld_c_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,n"});
}
pub fn rrca(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RRCA"});
}
pub fn stop(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"STOP"});
}
pub fn ld_de_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD DE,nn"});
}
pub fn ld_de_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (DE),A"});
}
pub fn inc_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC DE"});
}
pub fn inc_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC D"});
}
pub fn dec_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC D"});
}
pub fn ld_d_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,n"});
}
pub fn rla(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RLA"});
}
pub fn jr_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR n"});
}
pub fn add_hl_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,DE"});
}
pub fn ld_a_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(DE)"});
}
pub fn dec_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC DE"});
}
pub fn inc_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC E"});
}
pub fn dec_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC E"});
}
pub fn ld_e_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,n"});
}
pub fn rra(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RRA"});
}
pub fn jr_nz_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR NZ,n"});
}
pub fn ld_hl_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD HL,nn"});
}
pub fn ldi_hl_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDI (HL),A"});
}
pub fn inc_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC HL"});
}
pub fn inc_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC H"});
}
pub fn dec_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC H"});
}
pub fn ld_h_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,n"});
}
pub fn daa(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DAA"});
}
pub fn jr_z_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR Z,n"});
}
pub fn add_hl_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,HL"});
}
pub fn ldi_a_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDI A,(HL)"});
}
pub fn dec_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC HL"});
}
pub fn inc_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC L"});
}
pub fn dec_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC L"});
}
pub fn ld_l_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,n"});
}
pub fn cpl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CPL"});
}
pub fn jr_nc_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR NC,n"});
}
pub fn ld_sp_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,nn"});
}
pub fn ldd_hl_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDD (HL),A"});
}
pub fn inc_sp(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC SP"});
}
pub fn inc_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC (HL)"});
}
pub fn dec_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC (HL)"});
}
pub fn ld_hli_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),n"});
}
pub fn scf(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SCF"});
}
pub fn jr_c_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JR C,n"});
}
pub fn add_hl_sp(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD HL,SP"});
}
pub fn ldd_a_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LDD A,(HL)"});
}
pub fn dec_sp(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC SP"});
}
pub fn inc_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"INC A"});
}
pub fn dec_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DEC A"});
}
pub fn ld_a_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,n"});
}
pub fn ccf(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CCF"});
}
pub fn ld_b_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,B"});
}
pub fn ld_b_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,C"});
}
pub fn ld_b_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,D"});
}
pub fn ld_b_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,E"});
}
pub fn ld_b_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,H"});
}
pub fn ld_b_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,L"});
}
pub fn ld_b_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,(HL)"});
}
pub fn ld_b_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD B,A"});
}
pub fn ld_c_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,B"});
}
pub fn ld_c_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,C"});
}
pub fn ld_c_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,D"});
}
pub fn ld_c_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,E"});
}
pub fn ld_c_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,H"});
}
pub fn ld_c_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,L"});
}
pub fn ld_c_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,(HL)"});
}
pub fn ld_c_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD C,A"});
}
pub fn ld_d_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,B"});
}
pub fn ld_d_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,C"});
}
pub fn ld_d_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,D"});
}
pub fn ld_d_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,E"});
}
pub fn ld_d_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,H"});
}
pub fn ld_d_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,L"});
}
pub fn ld_d_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,(HL)"});
}
pub fn ld_d_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD D,A"});
}
pub fn ld_e_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,B"});
}
pub fn ld_e_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,C"});
}
pub fn ld_e_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,D"});
}
pub fn ld_e_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,E"});
}
pub fn ld_e_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,H"});
}
pub fn ld_e_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,L"});
}
pub fn ld_e_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,(HL)"});
}
pub fn ld_e_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD E,A"});
}
pub fn ld_h_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,B"});
}
pub fn ld_h_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,C"});
}
pub fn ld_h_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,D"});
}
pub fn ld_h_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,E"});
}
pub fn ld_h_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,H"});
}
pub fn ld_h_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,L"});
}
pub fn ld_h_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,(HL)"});
}
pub fn ld_h_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD H,A"});
}
pub fn ld_l_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,B"});
}
pub fn ld_l_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,C"});
}
pub fn ld_l_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,D"});
}
pub fn ld_l_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,E"});
}
pub fn ld_l_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,H"});
}
pub fn ld_l_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,L"});
}
pub fn ld_l_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,(HL)"});
}
pub fn ld_l_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD L,A"});
}
pub fn ld_hli_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),B"});
}
pub fn ld_hli_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),C"});
}
pub fn ld_hli_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),D"});
}
pub fn ld_hli_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),E"});
}
pub fn ld_hli_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),H"});
}
pub fn ld_hli_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),L"});
}
pub fn halt(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"HALT"});
}
pub fn ld_hli_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (HL),A"});
}
pub fn ld_a_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,B"});
}
pub fn ld_a_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,C"});
}
pub fn ld_a_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,D"});
}
pub fn ld_a_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,E"});
}
pub fn ld_a_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,H"});
}
pub fn ld_a_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,L"});
}
pub fn ld_a_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(HL)"});
}
pub fn ld_a_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,A"});
}
pub fn add_a_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,B"});
}
pub fn add_a_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,C"});
}
pub fn add_a_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,D"});
}
pub fn add_a_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,E"});
}
pub fn add_a_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,H"});
}
pub fn add_a_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,L"});
}
pub fn add_a_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,(HL)"});
}
pub fn add_a_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,A"});
}
pub fn adc_a_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,B"});
}
pub fn adc_a_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,C"});
}
pub fn adc_a_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,D"});
}
pub fn adc_a_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,E"});
}
pub fn adc_a_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,H"});
}
pub fn adc_a_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,L"});
}
pub fn adc_a_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,(HL)"});
}
pub fn adc_a_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,A"});
}
pub fn sub_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB B"});
}
pub fn sub_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB C"});
}
pub fn sub_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB D"});
}
pub fn sub_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB E"});
}
pub fn sub_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB H"});
}
pub fn sub_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB L"});
}
pub fn sub_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB (HL)"});
}
pub fn sub_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB A"});
}
pub fn sbc_a_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,B"});
}
pub fn sbc_a_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,C"});
}
pub fn sbc_a_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,D"});
}
pub fn sbc_a_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,E"});
}
pub fn sbc_a_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,H"});
}
pub fn sbc_a_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,L"});
}
pub fn sbc_a_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,(HL)"});
}
pub fn sbc_a_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,A"});
}
pub fn and_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND B"});
}
pub fn and_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND C"});
}
pub fn and_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND D"});
}
pub fn and_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND E"});
}
pub fn and_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND H"});
}
pub fn and_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND L"});
}
pub fn and_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND (HL)"});
}
pub fn and_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND A"});
}
pub fn xor_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR B"});
}
pub fn xor_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR C"});
}
pub fn xor_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR D"});
}
pub fn xor_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR E"});
}
pub fn xor_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR H"});
}
pub fn xor_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR L"});
}
pub fn xor_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR (HL)"});
}
pub fn xor_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR A"});
}
pub fn or_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR B"});
}
pub fn or_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR C"});
}
pub fn or_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR D"});
}
pub fn or_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR E"});
}
pub fn or_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR H"});
}
pub fn or_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR L"});
}
pub fn or_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR (HL)"});
}
pub fn or_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR A"});
}
pub fn cp_b(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP B"});
}
pub fn cp_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP C"});
}
pub fn cp_d(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP D"});
}
pub fn cp_e(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP E"});
}
pub fn cp_h(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP H"});
}
pub fn cp_l(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP L"});
}
pub fn cp_hli(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP (HL)"});
}
pub fn cp_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP A"});
}
pub fn ret_nz(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET NZ"});
}
pub fn pop_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP BC"});
}
pub fn jp_nz_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP NZ,nn"});
}
pub fn jp_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP nn"});
}
pub fn call_nz_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL NZ,nn"});
}
pub fn push_bc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH BC"});
}
pub fn add_a_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD A,n"});
}
pub fn rst_00(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 00"});
}
pub fn ret_z(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET Z"});
}
pub fn ret(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET"});
}
pub fn jp_z_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP Z,nn"});
}
pub fn call_z_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL Z,nn"});
}
pub fn call_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL nn"});
}
pub fn adc_a_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADC A,n"});
}
pub fn rst_08(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 08"});
}
pub fn ret_nc(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET NC"});
}
pub fn pop_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP DE"});
}
pub fn jp_nc_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP NC,nn"});
}
pub fn call_nc_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL NC,nn"});
}
pub fn push_de(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH DE"});
}
pub fn sub_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SUB n"});
}
pub fn rst_10(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 10"});
}
pub fn ret_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RET C"});
}
pub fn reti(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RETI"});
}
pub fn jp_c_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP C,nn"});
}
pub fn call_c_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL C,nn"});
}
pub fn sbc_a_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"SBC A,n"});
}
pub fn rst_18(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 18"});
}
pub fn ld_nn_a(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),A"});
}
pub fn pop_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP HL"});
}
pub fn ld_a_nn(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(nn)"});
}
pub fn di(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DI"});
}
pub fn push_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH HL"});
}
pub fn and_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"AND n"});
}
pub fn rst_20(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 20"});
}
pub fn add_sp_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"ADD SP,n"});
}
pub fn jp_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"JP (HL)"});
}
pub fn ld_nn_a2(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD (nn),A"});
}
pub fn ei(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"EI"});
}
pub fn call_nn2(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL nn"});
}
pub fn xor_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"XOR n"});
}
pub fn rst_28(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 28"});
}
pub fn ld_a_from_c(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(C)"});
}
pub fn pop_af(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"POP AF"});
}
pub fn ld_a_nn2(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(nn)"});
}
pub fn di2(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"DI"});
}
pub fn push_af(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PUSH AF"});
}
pub fn or_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"OR n"});
}
pub fn rst_30(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 30"});
}
pub fn ld_sp_hl(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD SP,HL"});
}
pub fn ld_hl_sp_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD HL,SP+n"});
}
pub fn ld_a_nn3(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"LD A,(nn)"});
}
pub fn ei2(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"EI"});
}
pub fn call_nn3(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CALL nn"});
}
pub fn cp_n(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"CP n"});
}
pub fn rst_38(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"RST 38"});
}
pub fn prefix_cb(_: *Cpu, _: *const Memory) void {
    std.debug.print("RUN OPCODE: {s}\n", .{"PREFIX CB"});
}
