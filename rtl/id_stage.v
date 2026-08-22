// ============================================
// ID Stage — Decode + Register File Read
// RISC-V Lite CPU — Week 4
// ============================================
module id_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] instruction,

    // Write-back inputs (WB stage-la irundhu varum, apparam connect pannuvom)
    input  wire [2:0]  wb_rd,
    input  wire [7:0]  wb_data,
    input  wire        wb_wr_en,

    output wire [3:0]  opcode,
    output wire [2:0]  rd_out,
    output wire [7:0]  rs1_data,
    output wire [7:0]  rs2_data
);
    wire [2:0] rd, rs1, rs2;

    decoder dec_unit (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );

    reg_file regfile_unit (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs1_data(rs1_data),
        .rs2(rs2),
        .rs2_data(rs2_data),
        .rd(wb_rd),
        .rd_data(wb_data),
        .wr_en(wb_wr_en)
    );

    assign rd_out = rd;
endmodule
