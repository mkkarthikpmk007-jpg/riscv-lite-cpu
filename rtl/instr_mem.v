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
    initial begin
        mem[0] = 16'h1123;  // e.g. ADD R1, R2, R3  (dummy encoding)
        mem[1] = 16'h2145;  // e.g. SUB R1, R4, R5
        mem[2] = 16'h3167;  // e.g. AND R1, R6, R7
        mem[3] = 16'h0000;  // NOP
        // ... baaki locations default 0
    end

    // Combinational read — address kudutha udane instruction varum
    assign instruction = mem[addr];
endmodule
