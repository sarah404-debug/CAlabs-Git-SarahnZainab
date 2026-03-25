//`timescale 1ns/1ps

//module switches(
//    input clk,
//    input rst,
//    input [31:0] writeData,
//    input writeEnable,
//    input readEnable,
//    input [29:0] memAddress,
//    output reg [31:0] readData = 0,
//    output reg [15:0] leds // This is the signal for the FSM
//);
//    always @(posedge clk or posedge rst) begin
//        if (rst) leds <= 16'b0;
//        else leds <= writeData[15:0]; // Direct latch of switch state
//    end
//endmodule



`timescale 1ns/1ps

module switches(
    input clk, rst,
    input [15:0] btns,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    input [15:0] switches,
    output reg [31:0] readData
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        readData <= 32'b0;
    else if (readEnable)
        readData <= {16'b0, switches};
end

endmodule