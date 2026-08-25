// ============================================
// MEM Stage
// RISC-V Lite CPU — Week 6
// ============================================
module mem_stage (
    input  wire       clk,
    input  wire [3:0] opcode,
    input  wire [7:0] alu_result,   // address for LW/SW
    input  wire [7:0] rs2_data,     // SW-ku store panna data

    output wire [7:0] mem_out       // LW result OR alu_result pass-through
);
    wire mem_write, mem_read;
    wire [7:0] read_data;

    // opcode 0101 = LW, opcode 0110 = SW (example encoding)
    assign mem_write = (opcode == 4'b0110);
    assign mem_read  = (opcode == 4'b0101);

    data_mem dmem_unit (
        .clk(clk),
        .addr(alu_result),
        .write_data(rs2_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    // LW na memory-la irundhu data, illana ALU result nேrடா pass pannu
    assign mem_out = mem_read ? read_data : alu_result;
endmodule
