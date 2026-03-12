//`timescale 1ns/1ps

//module dataMemory(

//    input clk,
//    input MemWrite,
//    input [8:0] address,
//    input [31:0] writeData,

//    output reg [31:0] readData
//);

//reg [31:0] memory [0:511];

//always @(posedge clk)
//begin

//    if(MemWrite)
//        memory[address] <= writeData;

//    readData <= memory[address];

//end

//endmodule



`timescale 1ns/1ps

module dataMemory(

    input clk,
    input MemWrite,
    input [8:0] address,
    input [31:0] writeData,

    output reg [31:0] readData
);

reg [31:0] memory [0:511];

always @(posedge clk)
begin

    if(MemWrite)
        memory[address] <= writeData;

    readData <= memory[address];

end

endmodule