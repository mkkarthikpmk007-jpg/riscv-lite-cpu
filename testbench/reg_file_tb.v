// ============================================
// Register File Testbench
// ============================================

`timescale 1ns/1ps

module reg_file_tb;

    reg        clk, rst;
    reg  [2:0] rs1, rs2, rd;
    reg  [7:0] rd_data;
    reg        wr_en;
    wire [7:0] rs1_data, rs2_data;

    // Connect Register File
    reg_file uut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),      .rs1_data(rs1_data),
        .rs2(rs2),      .rs2_data(rs2_data),
        .rd(rd),        .rd_data(rd_data),
        .wr_en(wr_en)
    );

    // Waveform dump
    initial begin
        $dumpfile("sim_output/reg_wave.vcd");
        $dumpvars(0, reg_file_tb);
    end

    // Clock — 10ns period
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0; rst = 1;
        rs1 = 0; rs2 = 0;
        rd  = 0; rd_data = 0;
        wr_en = 0;

        $display("=====================================");
        $display("   Register File Testbench Start     ");
        $display("=====================================");

        // Reset release
        #10 rst = 0;

        // Test 1: Write 42 to R1
        rd = 3'd1; rd_data = 8'd42; wr_en = 1;
        #10;
        $display("Write R1 = 42");

        // Test 2: Write 99 to R3
        rd = 3'd3; rd_data = 8'd99; wr_en = 1;
        #10;
        $display("Write R3 = 99");

        // Test 3: Read R1 + R3
        wr_en = 0;
        rs1 = 3'd1; rs2 = 3'd3;
        #10;
        $display("Read R1 = %0d (expect 42)", rs1_data);
        $display("Read R3 = %0d (expect 99)", rs2_data);

        // Test 4: Try write to R0 (should stay 0!)
        rd = 3'd0; rd_data = 8'd255; wr_en = 1;
        #10;
        rs1 = 3'd0;
        wr_en = 0;
        #10;
        $display("Read R0 = %0d (expect 0 always!)", rs1_data);

        // Test 5: Write R1, read immediately
        rd = 3'd1; rd_data = 8'd77; wr_en = 1;
        #10;
        rs1 = 3'd1; wr_en = 0;
        #10;
        $display("R1 updated = %0d (expect 77)", rs1_data);

        // Test 6: ALU result store pannunga (real use case)
        // ADD R2 = R1 + R3 → 77 + 99 = 176
        rd = 3'd2; rd_data = 8'd176; wr_en = 1;
        #10;
        rs1 = 3'd1; rs2 = 3'd2; wr_en = 0;
        #10;
        $display("R1=%0d, R2=%0d (ALU result stored)", rs1_data, rs2_data);

        $display("=====================================");
        $display("   All Tests Done!                  ");
        $display("=====================================");
        $finish;
    end

endmodule
