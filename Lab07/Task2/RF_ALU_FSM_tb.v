`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

reg clk;
reg rst;

reg writeEnable;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg [31:0] writeData;

wire [31:0] readData1;
wire [31:0] readData2;

reg [3:0] ALUControl;

wire [31:0] ALUResult;
wire Zero;

RegisterFile RF(
    .clk(clk),
    .rst(rst),
    .writeEnable(writeEnable),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);

ALU alu(
    .A(readData1),
    .B(readData2),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

initial clk = 0;
always #5 clk = ~clk;

parameter IDLE=0;
parameter WRITE_REGS=1;
parameter READ_REGS=2;
parameter ALU_OP=3;
parameter WRITE_BACK=4;
parameter DONE=5;

reg [2:0] state;
reg [3:0] opIndex;

always @(posedge clk) begin

    if(rst) begin
        state <= IDLE;
        opIndex <= 0;
    end

    else begin

        case(state)

        IDLE:
        state <= WRITE_REGS;

        WRITE_REGS:
        begin
            writeEnable <= 1;
            rd <= 1;
            writeData <= 32'h10101010;
            state <= READ_REGS;
        end

        READ_REGS:
        begin
            writeEnable <= 0;
            rs1 <= 1;
            rs2 <= 2;
            state <= ALU_OP;
        end

        ALU_OP:
        begin
            case(opIndex)

            0: ALUControl <= 4'b0000; // ADD
            1: ALUControl <= 4'b0001; // SUB
            2: ALUControl <= 4'b0010; // AND
            3: ALUControl <= 4'b0011; // OR
            4: ALUControl <= 4'b0100; // XOR
            5: ALUControl <= 4'b0101; // SLL
            6: ALUControl <= 4'b0110; // SRL
            7: ALUControl <= 4'b0111; // BEQ

            endcase

            state <= WRITE_BACK;
        end

        WRITE_BACK:
        begin
            writeEnable <= 1;
            rd <= opIndex + 4;
            writeData <= ALUResult;

            opIndex <= opIndex + 1;

            if(opIndex == 7)
                state <= DONE;
            else
                state <= READ_REGS;
        end

        DONE:
        begin
            writeEnable <= 0;
            $display("All ALU operations completed.");
            $finish;
        end

        endcase

    end

end

initial begin

rst = 1;
#20 rst = 0;

end

endmodule