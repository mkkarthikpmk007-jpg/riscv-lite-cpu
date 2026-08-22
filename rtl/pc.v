// ============================================
// Program Counter (PC)
// RISC-V Lite CPU — Week 3
// ============================================
module pc (
    input  wire       clk,
    input  wire       rst,
    input  wire        pc_write,   // stall panna venuma nu control
    input  wire [7:0] pc_next,    // next PC value (branch/jump target or PC+1)
    output reg  [7:0] pc_out      // current PC value
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 8'd0;          // start from instruction 0
        else if (pc_write)
            pc_out <= pc_next;       // update PC
    end
endmodule

