`timescale 1ns/1ps

module riscv_cpu_tb;
    reg clk, rst;
    
    riscv_cpu uut (
        .clk(clk),
        .rst(rst)
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
        
        // 10 clock cycles
        repeat (10) begin
            #10;
            
            // Debug output
            $display("Time=%0t PC=%0d Instr=%h opcode=%b ALU_result=%0d | RS1_data=%0d RS2_data=%0d", 
                $time, uut.pc_out, uut.if_instruction, uut.id_opcode, uut.ex_alu_result,
                uut.id_rs1_data, uut.id_rs2_data);
            
            // Expected values check
            if (uut.pc_out == 4'd1) 
                $display("    EXPECTED: ADD R2(20) + R3(5) = 25, GOT: %0d", uut.ex_alu_result);
            if (uut.pc_out == 4'd2) 
                $display("    EXPECTED: SUB R4(50) - R5(15) = 35, GOT: %0d", uut.ex_alu_result);
            if (uut.pc_out == 4'd3) 
                $display("    EXPECTED: AND R6(12) & R7(10) = 8, GOT: %0d", uut.ex_alu_result);
        end
        
        $display("=====================================");
        $display("         Simulation Done!             ");
        $display("=====================================");
        $finish;
    end
    
endmodule
