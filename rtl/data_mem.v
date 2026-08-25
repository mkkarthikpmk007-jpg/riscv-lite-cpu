// ============================================
// Data Memory
// RISC-V Lite CPU — Week 6
// ============================================
module data_mem (
    input  wire       clk,
    input  wire [7:0] addr,        // memory address (from ALU result)
    input  wire [7:0] write_data,  // SW-ku data
    input  wire       mem_write,   // SW instruction na 1
    input  wire       mem_read,    // LW instruction na 1
    output wire [7:0] read_data    // LW-ku output
);
    reg [7:0] mem [0:255];  // 256 locations x 8-bit

    // Write logic — clock edge-la
    always @(posedge clk) begin
        if (mem_write)
            mem[addr] <= write_data;
    end

    // Read logic — combinational
    assign read_data = (mem_read) ? mem[addr] : 8'd0;
endmodule
