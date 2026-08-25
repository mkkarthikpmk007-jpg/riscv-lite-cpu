// ============================================
// MEM + WB Stage Testbench
// ============================================
`timescale 1ns/1ps
module mem_wb_tb;

    reg        clk;
    reg  [3:0] opcode;
    reg  [7:0] alu_result, rs2_data;
    wire [7:0] mem_out, wb_data;
    wire       wb_wr_en;

    mem_stage mem_uut (
        .clk(clk),
        .opcode(opcode),
        .alu_result(alu_result),
        .rs2_data(rs2_data),
        .mem_out(mem_out)
    );

    wb_stage wb_uut (
        .opcode(opcode),
        .mem_out(mem_out),
        .wb_data(wb_data),
        .wb_wr_en(wb_wr_en)
    );

    initial begin
        $dumpfile("sim_output/mem_wb_wave.vcd");
        $dumpvars(0, mem_wb_tb);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 0;

        $display("=====================================");
        $display("    MEM + WB Stage Testbench Start    ");
        $display("=====================================");

        // Test 1: ADD result (opcode 0001) — MEM skip, WB write
        opcode = 4'b0001; alu_result = 8'd25; rs2_data = 8'd0;
        #10;
        $display("ADD: mem_out=%0d wb_data=%0d wb_wr_en=%b (expect 25,25,1)",
                   mem_out, wb_data, wb_wr_en);

        // Test 2: SW — store 42 at address 10
        opcode = 4'b0110; alu_result = 8'd10; rs2_data = 8'd42;
        #10;
        $display("SW: mem_out=%0d wb_wr_en=%b (expect wr_en=0, no register write)",
                   mem_out, wb_wr_en);

        // Test 3: LW — load from address 10 (should get back 42)
        opcode = 4'b0101; alu_result = 8'd10; rs2_data = 8'd0;
        #10;
        $display("LW: mem_out=%0d wb_data=%0d wb_wr_en=%b (expect 42,42,1)",
                   mem_out, wb_data, wb_wr_en);

        $display("=====================================");
        $display("         All Tests Done!              ");
        $display("=====================================");
        $finish;
    end
endmodule

