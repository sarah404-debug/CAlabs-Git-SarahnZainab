//`timescale 1ns / 1ps

//module top_rf_alu(

//    input clk,
//    input rst,

//    input [3:0] sw,        // ALU operation select

//    output [15:0] led      // result + state display
//);

//wire [31:0] readData1;
//wire [31:0] readData2;

//wire [31:0] ALUResult;
//wire Zero;

//reg writeEnable;

//reg [4:0] rs1;
//reg [4:0] rs2;
//reg [4:0] rd;

//reg [31:0] writeData;

//reg [3:0] ALUControl;


//// instantiate Register File
//RegisterFile RF(

//    .clk(clk),
//    .rst(rst),
//    .writeEnable(writeEnable),

//    .rs1(rs1),
//    .rs2(rs2),
//    .rd(rd),

//    .writeData(writeData),

//    .readData1(readData1),
//    .readData2(readData2)

//);


//// instantiate ALU
//ALU alu(

//    .A(readData1),
//    .B(readData2),
//    .ALUControl(ALUControl),

//    .ALUResult(ALUResult),
//    .Zero(Zero)

//);


//// FSM states
//parameter INIT = 0;
//parameter WRITE_A = 1;
//parameter WRITE_B = 2;
//parameter READ = 3;
//parameter EXECUTE = 4;

//reg [2:0] state;


//always @(posedge clk)
//begin

//if(rst)
//begin

//state <= INIT;
//writeEnable <= 0;

//end


//else
//begin

//case(state)

//INIT:
//begin
//state <= WRITE_A;
//end


//// write constant A to x1
//WRITE_A:
//begin

//writeEnable <= 1;

//rd <= 5'd1;
//writeData <= 32'h10101010;

//state <= WRITE_B;

//end


//// write constant B to x2
//WRITE_B:
//begin

//rd <= 5'd2;
//writeData <= 32'h01010101;

//state <= READ;

//end


//// read registers
//READ:
//begin

//writeEnable <= 0;

//rs1 <= 5'd1;
//rs2 <= 5'd2;

//state <= EXECUTE;

//end


//// perform ALU
//EXECUTE:
//begin

//ALUControl <= sw;

//state <= EXECUTE;

//end

//endcase

//end

//end


//// show ALU result on LEDs
//assign led[15:0] = ALUResult[15:0];


//endmodule


`timescale 1ns / 1ps

module top_rf_alu(

    input clk,
    input rst,

    input [15:0] sw,
    input [15:0] btns,

    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
);

wire [31:0] readData1;
wire [31:0] readData2;

wire [31:0] ALUResult;
wire Zero;

reg writeEnable;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg [31:0] writeData;

reg [3:0] ALUControl;

reg readEnable;

wire [31:0] switchData;


// Register File
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


// ALU
ALU alu(

    .A(readData1),
    .B(readData2),
    .ALUControl(ALUControl),

    .ALUResult(ALUResult),
    .Zero(Zero)

);


// SWITCH INPUT MODULE
switches sw_mod(

    .clk(clk),
    .rst(rst),
    .btns(btns),

    .writeData(32'b0),
    .writeEnable(0),
    .readEnable(1),
    .memAddress(30'b0),

    .switches(sw),
    .readData(switchData)

);


// LED OUTPUT MODULE
leds led_mod(

    .clk(clk),
    .rst(rst),

    .writeData(ALUResult),
    .writeEnable(1),
    .readEnable(0),
    .memAddress(30'b0),

    .readData(),
    .leds(led)

);


// SEVEN SEGMENT DISPLAY
sevenseg_basys3 sevenseg(

    .clk(clk),
    .value(ALUResult[15:0]),

    .seg(seg),
    .an(an)

);


// FSM states
parameter INIT = 0;
parameter WRITE_A = 1;
parameter WRITE_B = 2;
parameter READ = 3;
parameter EXECUTE = 4;

reg [2:0] state;


always @(posedge clk)
begin

if(rst)
begin

state <= INIT;
writeEnable <= 0;

end

else
begin

case(state)

INIT:
state <= WRITE_A;


// write constant A
WRITE_A:
begin

writeEnable <= 1;

rd <= 5'd1;
writeData <= 32'h10101010;

state <= WRITE_B;

end


// write constant B
WRITE_B:
begin

rd <= 5'd2;
writeData <= 32'h01010101;

state <= READ;

end


// read registers
READ:
begin

writeEnable <= 0;

rs1 <= 5'd1;
rs2 <= 5'd2;

state <= EXECUTE;

end


// execute ALU
EXECUTE:
begin

ALUControl <= switchData[3:0];

state <= EXECUTE;

end

endcase

end

end

endmodule