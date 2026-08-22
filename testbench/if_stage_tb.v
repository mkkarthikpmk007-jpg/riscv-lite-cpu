// ============================================
// IF Stage Testbench
// ============================================
`timescale 1ns/1ps
module if_stage_tb;

    reg        clk, rst, pc_write;
    reg  [7:0] pc_next;
    wire [7:0] pc_out;
    wire [15:0] instruction;

    if_stage uut (
        .clk(clk),
        .rst(rst),
        .pc_write(pc_write),
        .pc_next(pc_next),
        .pc_out(pc_out),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("sim_output/if_wave.vcd");
        $dumpvars(0, if_stage_tb);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; pc_write = 0; pc_next = 8'd0;

        $display("=====================================");
        $display("      IF Stage Testbench Start        ");
        $display("=====================================");

        #10 rst = 0;

        // Simple PC increment simulation: 0 -> 1 -> 2 -> 3
        pc_write = 1;

        pc_next = 8'd0; #10;
        $display("PC=%0d, Instruction=%h", pc_out, instruction);

        pc_next = 8'd1; #10;
        $display("PC=%0d, Instruction=%h", pc_out, instruction);

        pc_next = 8'd2; #10;
        $display("PC=%0d, Instruction=%h", pc_out, instruction);

        pc_next = 8'd3; #10;
        $display("PC=%0d, Instruction=%h", pc_out, instruction);

        $display("=====================================");
        $display("      All Tests Done!                 ");
        $display("=====================================");
        $finish;
    end
endmodule

