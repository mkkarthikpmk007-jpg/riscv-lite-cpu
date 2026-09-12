module riscv_cpu (
    input  wire       clk,
    input  wire       rst,
    output wire [7:0] debug_pc,
    output wire [7:0] debug_alu_result,
    output wire [7:0] debug_wb_data,
    output wire       debug_wb_wr_en
);

    // ---------------- IF Stage ----------------
    wire [7:0]  pc_out;
    wire [15:0] if_instruction;
    reg  [7:0]  pc_next;

    if_stage IF (
        .clk(clk),
        .rst(rst),
        .pc_write(1'b1),
        .pc_next(pc_next),
        .pc_out(pc_out),
        .instruction(if_instruction)
    );

    always @(*) begin
        pc_next = pc_out + 8'd1;
    end

    // ---------------- IF/ID Pipeline Register ----------------
    reg [15:0] if_id_instruction;

    always @(posedge clk or posedge rst) begin
        if (rst)
            if_id_instruction <= 16'd0;
        else
            if_id_instruction <= if_instruction;
    end

    // ---------------- ID Stage ----------------
    wire [3:0] id_opcode;
    wire [2:0] id_rd;
    wire [7:0] id_rs1_data, id_rs2_data;

    wire [2:0] wb_rd_final;
    wire [7:0] wb_data_final;
    wire       wb_wr_en_final;

    id_stage ID (
        .clk(clk),
        .rst(rst),
        .instruction(if_id_instruction),
        .wb_rd(wb_rd_final),
        .wb_data(wb_data_final),
        .wb_wr_en(wb_wr_en_final),
        .opcode(id_opcode),
        .rd_out(id_rd),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data)
    );

    // ---------------- ID/EX Pipeline Register ----------------
    reg [3:0] id_ex_opcode;
    reg [2:0] id_ex_rd;
    reg [7:0] id_ex_rs1_data, id_ex_rs2_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_ex_opcode   <= 4'd0;
            id_ex_rd       <= 3'd0;
            id_ex_rs1_data <= 8'd0;
            id_ex_rs2_data <= 8'd0;
        end else begin
            id_ex_opcode   <= id_opcode;
            id_ex_rd       <= id_rd;
            id_ex_rs1_data <= id_rs1_data;
            id_ex_rs2_data <= id_rs2_data;
        end
    end

    // ---------------- EX Stage ----------------
    wire [7:0] ex_alu_result;
    wire       ex_zero_flag;

    ex_stage EX (
        .opcode(id_ex_opcode),
        .rs1_data(id_ex_rs1_data),
        .rs2_data(id_ex_rs2_data),
        .alu_result(ex_alu_result),
        .zero_flag(ex_zero_flag)
    );

    // ---------------- EX/MEM Pipeline Register ----------------
    reg [3:0] ex_mem_opcode;
    reg [2:0] ex_mem_rd;
    reg [7:0] ex_mem_alu_result, ex_mem_rs2_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_mem_opcode     <= 4'd0;
            ex_mem_rd         <= 3'd0;
            ex_mem_alu_result <= 8'd0;
            ex_mem_rs2_data   <= 8'd0;
        end else begin
            ex_mem_opcode     <= id_ex_opcode;
            ex_mem_rd         <= id_ex_rd;
            ex_mem_alu_result <= ex_alu_result;
            ex_mem_rs2_data   <= id_ex_rs2_data;
        end
    end

    // ---------------- MEM Stage ----------------
    wire [7:0] mem_out;

    mem_stage MEM (
        .clk(clk),
        .opcode(ex_mem_opcode),
        .alu_result(ex_mem_alu_result),
        .rs2_data(ex_mem_rs2_data),
        .mem_out(mem_out)
    );

    // ---------------- MEM/WB Pipeline Register ----------------
    reg [3:0] mem_wb_opcode;
    reg [2:0] mem_wb_rd;
    reg [7:0] mem_wb_mem_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_wb_opcode  <= 4'd0;
            mem_wb_rd      <= 3'd0;
            mem_wb_mem_out <= 8'd0;
        end else begin
            mem_wb_opcode  <= ex_mem_opcode;
            mem_wb_rd      <= ex_mem_rd;
            mem_wb_mem_out <= mem_out;
        end
    end

    // ---------------- WB Stage ----------------
    wb_stage WB (
        .opcode(mem_wb_opcode),
        .mem_out(mem_wb_mem_out),
        .wb_data(wb_data_final),
        .wb_wr_en(wb_wr_en_final)
    );

    assign wb_rd_final = mem_wb_rd;

    // ---------------- Debug outputs ----------------
    assign debug_pc         = pc_out;
    assign debug_alu_result = ex_alu_result;
    assign debug_wb_data    = wb_data_final;
    assign debug_wb_wr_en   = wb_wr_en_final;

endmodule
