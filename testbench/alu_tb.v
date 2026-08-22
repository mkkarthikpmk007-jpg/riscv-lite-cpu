// ============================================
// ALU Testbench
// ============================================

`timescale 1ns/1ps

module alu_tb;

    // Inputs
    reg [7:0] A, B;
    reg [2:0] op;

    // Outputs
    wire [7:0] result;
    wire       zero_flag;

    // Connect ALU
    alu uut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero_flag(zero_flag)
    );

    // Waveform dump — GTKWave ku
    initial begin
        $dumpfile("sim_output/alu_wave.vcd");
        $dumpvars(0, alu_tb);
    end

    // Test cases
    initial begin
        $display("=============================");
        $display("   ALU Testbench Starting    ");
        $display("=============================");

        // Test 1: ADD
        A = 8'd10; B = 8'd5; op = 3'b000;
        #10;
        $display("ADD: %0d + %0d = %0d | zero=%b", A, B, result, zero_flag);

        // Test 2: SUB
        A = 8'd10; B = 8'd5; op = 3'b001;
        #10;
        $display("SUB: %0d - %0d = %0d | zero=%b", A, B, result, zero_flag);

        // Test 3: AND
        A = 8'b11001100; B = 8'b10101010; op = 3'b010;
        #10;
        $display("AND: %b & %b = %b | zero=%b", A, B, result, zero_flag);

        // Test 4: OR
        A = 8'b11001100; B = 8'b10101010; op = 3'b011;
        #10;
        $display("OR : %b | %b = %b | zero=%b", A, B, result, zero_flag);

        // Test 5: XOR
        A = 8'b11001100; B = 8'b11001100; op = 3'b100;
        #10;
        $display("XOR: %b ^ %b = %b | zero=%b", A, B, result, zero_flag);

        // Test 6: Zero flag check (SUB equal numbers)
        A = 8'd7; B = 8'd7; op = 3'b001;
        #10;
        $display("SUB: %0d - %0d = %0d | zero=%b (BEQ trigger!)", A, B, result, zero_flag);

        // Test 7: SLT
        A = 8'd3; B = 8'd9; op = 3'b101;
        #10;
        $display("SLT: %0d < %0d = %0d", A, B, result);

        $display("=============================");
        $display("   All Tests Done!          ");
        $display("=============================");
        $finish;
    end

endmodule
