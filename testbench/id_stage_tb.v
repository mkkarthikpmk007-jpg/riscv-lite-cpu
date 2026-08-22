// ============================================
// ID Stage Testbench
// ============================================
`timescale 1ns/1ps
module id_stage_tb;

    reg        clk, rst;
    reg [15:0] instruction;
    reg [2:0]  wb_rd;
    reg [7:0]  wb_data;
    reg        wb_wr_en;

    wire [3:0] opcode;
    wire [2:0] rd_out;
    wire [7:0] rs1_data, rs2_data;

    id_stage uut (
        .clk(clk), .rst(rst),
        .instruction(instruction),
        .wb_rd(wb_rd), .wb_data(wb_data), .wb_wr_en(wb_wr_en),
        .opcode(opcode), .rd_out(rd_out),
        .rs1_data(rs1_data), .rs2_data(rs2_data)
    );

    initial begin
        $dumpfile("sim_output/id_wave.vcd");
        $dumpvars(0, id_stage_tb);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        instruction = 16'h0000;
        wb_rd = 0; wb_data = 0; wb_wr_en = 0;

        $display("=====================================");
        $display("      ID Stage Testbench Start        ");
        $display("=====================================");

        #10 rst = 0;

        // Preload R2 = 20, R3 = 5 via write-back path
        wb_rd = 3'd2; wb_data = 8'd20; wb_wr_en = 1; #10;
        wb_rd = 3'd3; wb_data = 8'd5;  wb_wr_en = 1; #10;
        wb_wr_en = 0;

        // Instruction: opcode=0001(ADD), rd=001, rs1=010(R2), rs2=011(R3)
        instruction = 16'b0001_001_010_011_000; #10;
        $display("opcode=%b rd=%0d rs1_data=%0d rs2_data=%0d",
                   opcode, rd_out, rs1_data, rs2_data);
        $display("(expect: opcode=0001, rd=1, rs1_data=20, rs2_data=5)");

        $display("=====================================");
        $display("      All Tests Done!                 ");
        $display("=====================================");
        $finish;
    end
endmodule

