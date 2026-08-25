// ============================================
// WB Stage — Write Back
// RISC-V Lite CPU — Week 6
// ============================================
module wb_stage (
    input  wire [3:0] opcode,
    input  wire [7:0] mem_out,     // MEM stage-la irundhu final value

    output wire [7:0] wb_data,     // Register file-ku pogura data
    output wire       wb_wr_en     // write enable
);
    // SW mattum write pannadhu (memory-la already store pannitom)
    // BEQ mattum write pannadhu (branch-ku result illa)
    assign wb_wr_en = (opcode != 4'b0110) && (opcode != 4'b0111);  // 0111 = BEQ example
    assign wb_data  = mem_out;
endmodule
