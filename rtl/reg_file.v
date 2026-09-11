// ============================================
// Register File — 8 x 8-bit registers
// RISC-V Lite CPU — Week 2 (+ test preload on reset)
// ============================================
module reg_file (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] rs1,
    output wire [7:0] rs1_data,
    input  wire [2:0] rs2,
    output wire [7:0] rs2_data,
    input  wire [2:0] rd,
    input  wire [7:0] rd_data,
    input  wire       wr_en
);
    reg [7:0] registers [0:7];
    integer i;

    // Reset + Write logic — reset ippo test values load pannும்
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 8'd0;    // R0 always 0
            registers[1] <= 8'd0;
            registers[2] <= 8'd20;   // R2 = 20
            registers[3] <= 8'd5;    // R3 = 5
            registers[4] <= 8'd50;   // R4 = 50
            registers[5] <= 8'd15;   // R5 = 15
            registers[6] <= 8'b00001100; // R6 = 12
            registers[7] <= 8'b00001010; // R7 = 10
        end
        else if (wr_en && rd != 3'd0) begin
            registers[rd] <= rd_data;
        end
    end

    assign rs1_data = (rs1 == 3'd0) ? 8'd0 : registers[rs1];
    assign rs2_data = (rs2 == 3'd0) ? 8'd0 : registers[rs2];
endmodule
