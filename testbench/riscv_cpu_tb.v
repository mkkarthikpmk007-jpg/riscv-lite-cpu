`timescale 1ns/1ps
module riscv_cpu_tb;

    reg clk, rst;
    wire [7:0] debug_pc, debug_alu_result, debug_wb_data;
    wire       debug_wb_wr_en;

    riscv_cpu uut (
        .clk(clk),
        .rst(rst),
        .debug_pc(debug_pc),
        .debug_alu_result(debug_alu_result),
        .debug_wb_data(debug_wb_data),
        .debug_wb_wr_en(debug_wb_wr_en)
    );

    initial begin
        $dumpfile("sim_output/cpu_wave.vcd");
        $dumpvars(0, riscv_cpu_tb);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        $display("=====================================");
        $display("      Full CPU Testbench Start        ");
        $display("=====================================");
        #10 rst = 0;

        repeat (10) begin
            #10;
            $display("Time=%0t PC=%0d Instr=%h opcode(ID)=%b ALU_result=%0d",
                $time, uut.pc_out, uut.if_instruction, uut.id_opcode, uut.ex_alu_result);
        end

        $display("=====================================");
        $display("         Simulation Done!             ");
        $display("=====================================");
        $finish;
    end
endmodule
