// ============================================
// Instruction Memory (ROM)
// RISC-V Lite CPU — Week 3
// ============================================
module instr_mem (
    input  wire [7:0]  addr,        // PC value — which instruction?
    output wire [15:0] instruction  // 16-bit instruction out
);
    // 256 locations x 16-bit wide memory
    reg [15:0] mem [0:255];

    // Preload a few sample instructions for testing
    integer i;
initial begin
    for (i = 0; i < 256; i = i + 1)
        mem[i] = 16'h0000;

    mem[0] = 16'h1123;
    mem[1] = 16'h2145;
    mem[2] = 16'h3167;
end

    // Combinational read — address kudutha udane instruction varum
    assign instruction = mem[addr];
endmodule
