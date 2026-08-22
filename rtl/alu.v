

module alu (
    input  wire [7:0] A,        // First number
    input  wire [7:0] B,        // Second number
    input  wire [2:0] op,       // Operation select
    output reg  [7:0] result,   // Answer
    output wire       zero_flag // Result == 0? (used for BEQ)
);

    // Operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam SLT = 3'b101;  // Set Less Than

    always @(*) begin
        case (op)
            ADD : result = A + B;
            SUB : result = A - B;
            AND : result = A & B;
            OR  : result = A | B;
            XOR : result = A ^ B;
            SLT : result = ($signed(A) < $signed(B)) ? 8'd1 : 8'd0;
            default: result = 8'd0;
        endcase
    end

    // Zero flag — BEQ instruction use pannudu
    assign zero_flag = (result == 8'd0) ? 1'b1 : 1'b0;

endmodule
