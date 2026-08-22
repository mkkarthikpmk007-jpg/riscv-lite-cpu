// ============================================
// Register File — 8 x 8-bit registers
// RISC-V Lite CPU — Week 2
// Karthik / Vector X
// ============================================

module reg_file (
    input  wire       clk,        // Clock
    input  wire       rst,        // Reset
    
    // Read Port 1 (Rs1)
    input  wire [2:0] rs1,        // Register select 1
    output wire [7:0] rs1_data,   // Register 1 data out
    
    // Read Port 2 (Rs2)
    input  wire [2:0] rs2,        // Register select 2
    output wire [7:0] rs2_data,   // Register 2 data out
    
    // Write Port (Rd)
    input  wire [2:0] rd,         // Destination register
    input  wire [7:0] rd_data,    // Data to write
    input  wire       wr_en       // Write enable
);

    // 8 registers, each 8-bit wide
    reg [7:0] registers [0:7];

    integer i;

    // Reset + Write logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset — all registers 0
            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 8'd0;
        end
        else if (wr_en && rd != 3'd0) begin
            // Write — R0 always 0, never write!
            registers[rd] <= rd_data;
        end
    end

    // Read logic — combinational (instant)
    assign rs1_data = (rs1 == 3'd0) ? 8'd0 : registers[rs1];
    assign rs2_data = (rs2 == 3'd0) ? 8'd0 : registers[rs2];

endmodule
