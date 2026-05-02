`timescale 1ns / 1ps

module RegisterFile(
    input clk,
    input rst,
    input writeEnable,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);

    reg [31:0] regs [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (writeEnable && rd != 0) begin
            regs[rd] <= writeData;
        end
    end

    // Read ports (combinational) - x0 always reads as 0
    assign readData1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign readData2 = (rs2 == 0) ? 32'b0 : regs[rs2];

endmodule