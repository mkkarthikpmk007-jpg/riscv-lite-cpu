// ============================================
// EX Stage — ALU Execute
// RISC-V Lite CPU — Week 5
// ============================================
module ex_stage (
    input  wire [3:0] opcode,     // ID stage-la irundhu
    input  wire [7:0] rs1_data,   // ID stage-la irundhu
    input  wire [7:0] rs2_data,   // ID stage-la irundhu

    output wire [7:0] alu_result,
    output wire       zero_flag   // BEQ-ku use aagum (result==0?)
);
    wire [2:0] alu_op;

    // opcode -> ALU op mapping
    // opcode 0001 = ADD -> alu_op 000
    // opcode 0010 = SUB -> alu_op 001
    // opcode 0011 = AND -> alu_op 010
    // opcode 0100 = OR  -> alu_op 011
    assign alu_op = (opcode == 4'b0001) ? 3'b000 :
                     (opcode == 4'b0010) ? 3'b001 :
                     (opcode == 4'b0011) ? 3'b010 :
                     (opcode == 4'b0100) ? 3'b011 : 3'b000;

    alu alu_unit (
        .A(rs1_data),
        .B(rs2_data),
        .op(alu_op),
        .result(alu_result)
    );

    assign zero_flag = (alu_result == 8'd0);
endmodule

