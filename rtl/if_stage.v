// ============================================
// IF Stage — PC + Instruction Memory connected
// RISC-V Lite CPU — Week 3
// ============================================
module if_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire        pc_write,
    input  wire [7:0]  pc_next,     // adutha PC evlo nu vera logic sollum
    output wire [7:0]  pc_out,      // current PC (debug/next-stage-ku)
    output wire [15:0] instruction  // fetched instruction
);
    wire [7:0] pc_current;

    // Program Counter
    pc pc_unit (
        .clk(clk),
        .rst(rst),
        .pc_write(pc_write),
        .pc_next(pc_next),
        .pc_out(pc_current)
    );

    // Instruction Memory
    instr_mem imem_unit (
        .addr(pc_current),
        .instruction(instruction)
    );

    assign pc_out = pc_current;
endmodule

