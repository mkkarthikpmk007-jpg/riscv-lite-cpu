// ============================================
// EX Stage Testbench
// ============================================
`timescale 1ns/1ps
module ex_stage_tb;

    reg  [3:0] opcode;
    reg  [7:0] rs1_data, rs2_data;
    wire [7:0] alu_result;
    wire       zero_flag;

    ex_stage uut (
        .opcode(opcode),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );

    initial begin
        $dumpfile("sim_output/ex_wave.vcd");
        $dumpvars(0, ex_stage_tb);

        $display("=====================================");
        $display("      EX Stage Testbench Start        ");
        $display("=====================================");

        // Test 1: ADD 20 + 5 = 25
        opcode = 4'b0001; rs1_data = 8'd20; rs2_data = 8'd5;
        #10;
        $display("ADD: result=%0d zero=%b (expect result=25, zero=0)", alu_result, zero_flag);

        // Test 2: SUB 5 - 5 = 0 (zero flag check!)
        opcode = 4'b0010; rs1_data = 8'd5; rs2_data = 8'd5;
        #10;
        $display("SUB: result=%0d zero=%b (expect result=0, zero=1)", alu_result, zero_flag);

        // Test 3: AND
        opcode = 4'b0011; rs1_data = 8'b1100; rs2_data = 8'b1010;
        #10;
        $display("AND: result=%b (expect 1000)", alu_result);

        // Test 4: OR
        opcode = 4'b0100; rs1_data = 8'b1100; rs2_data = 8'b1010;
        #10;
        $display("OR: result=%b (expect 1110)", alu_result);

        $display("=====================================");
        $display("      All Tests Done!                 ");
        $display("=====================================");
        $finish;
    end
endmodule
