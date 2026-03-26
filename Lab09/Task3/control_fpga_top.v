//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 03/26/2026 10:54:29 AM
//// Design Name: 
//// Module Name: control_fpga_top
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

//module control_fpga_top(
//    input clk,
//    input rst,
//    input btnU,
//    input btnC,
//    input [15:0] switches,
//    output [15:0] leds
//);

//// -----------------------------
//// DEBOUNCERS (LAB 5)
//// -----------------------------
//wire readEnable_clean;
//wire writeEnable_clean;

//debouncer db_read (
//    .clk(clk),
//    .pbin(btnU),
//    .pbout(readEnable_clean)
//);

//debouncer db_write (
//    .clk(clk),
//    .pbin(btnC),
//    .pbout(writeEnable_clean)
//);

//// -----------------------------
//// SLOW CLOCK (LAB 9)
//// -----------------------------
//reg [25:0] counter;
//wire slowEnable;

//always @(posedge clk or posedge rst) begin
//    if (rst)
//        counter <= 0;
//    else
//        counter <= counter + 1;
//end

//assign slowEnable = counter[25];

//// -----------------------------
//// SWITCH MODULE (LAB 5)
//// -----------------------------
//wire [31:0] switchData;

//switches sw_inst(
//    .clk(clk),
//    .rst(rst),
//    .btns(16'b0),
//    .writeData(32'b0),
//    .writeEnable(1'b0),
//    .readEnable(1'b1),   // always active
//    .memAddress(30'b0),
//    .switches(switches),
//    .readData(switchData)
//);

//// Extract fields
//wire [6:0] opcode = switchData[6:0];
//wire [2:0] funct3 = switchData[9:7];
//wire [6:0] funct7 = switchData[15:9];

//// -----------------------------
//// CONTROL UNIT
//// -----------------------------
//wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
//wire [3:0] ALUControl;

//control_top ctrl(
//    .opcode(opcode),
//    .funct3(funct3),
//    .funct7(funct7),
//    .RegWrite(RegWrite),
//    .MemRead(MemRead),
//    .MemWrite(MemWrite),
//    .ALUSrc(ALUSrc),
//    .MemtoReg(MemtoReg),
//    .Branch(Branch),
//    .ALUControl(ALUControl)
//);

//// -----------------------------
//// FSM
//// -----------------------------
//reg [1:0] state;

//parameter IDLE = 2'b00,
//          READ = 2'b01,
//          DISPLAY = 2'b10;

//always @(posedge slowEnable or posedge rst) begin
//    if (rst)
//        state <= IDLE;
//    else begin
//        case(state)
//            IDLE: state <= READ;
//            READ: state <= DISPLAY;
//            DISPLAY: state <= READ;
//        endcase
//    end
//end

//// -----------------------------
//// LED MODULE (LAB 5)
//// -----------------------------
//wire [31:0] ledData;

//// Pack signals into 32-bit
//assign ledData = {
//    22'b0,
//    ALUControl,
//    Branch,
//    MemtoReg,
//    ALUSrc,
//    MemWrite,
//    MemRead,
//    RegWrite
//};

//leds led_inst(
//    .clk(clk),
//    .rst(rst),
//    .writeData(ledData),
//    .writeEnable(state == DISPLAY), // write only in display
//    .readEnable(1'b0),
//    .memAddress(30'b0),
//    .readData(),
//    .leds(leds)
//);

//endmodule




`timescale 1ns / 1ps

module control_fpga_top(
    input clk,
    input rst,
    input btnU,
    input btnC,
    input [15:0] switches,
    output [15:0] leds
);

// -----------------------------
// DEBOUNCERS
// -----------------------------
wire readEnable_clean;
wire writeEnable_clean;

debouncer db_read (
    .clk(clk),
    .pbin(btnU),
    .pbout(readEnable_clean)
);

debouncer db_write (
    .clk(clk),
    .pbin(btnC),
    .pbout(writeEnable_clean)
);

// -----------------------------
// SLOW CLOCK
// -----------------------------
reg [25:0] counter;
wire slowEnable;

always @(posedge clk or posedge rst) begin
    if (rst)
        counter <= 0;
    else
        counter <= counter + 1;
end

assign slowEnable = counter[25];

// -----------------------------
// SWITCH MODULE
// -----------------------------
wire [31:0] switchData;

switches sw_inst(
    .clk(clk),
    .rst(rst),
    .btns(16'b0),
    .writeData(32'b0),
    .writeEnable(1'b0),
    .readEnable(1'b1),
    .memAddress(30'b0),
    .switches(switches),
    .readData(switchData)
);

// -----------------------------
// FIELD EXTRACTION (FIXED)
// -----------------------------
wire [6:0] opcode = switchData[6:0];
wire [2:0] funct3 = switchData[9:7];

// ? FIXED: correct bit placement for funct7
wire [6:0] funct7 = {1'b0, switchData[10], 5'b00000};

// -----------------------------
// CONTROL UNIT
// -----------------------------
wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
wire [3:0] ALUControl;

control_top ctrl(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUControl(ALUControl)
);

// -----------------------------
// FSM
// -----------------------------
reg [1:0] state;

parameter IDLE = 2'b00,
          READ = 2'b01,
          DISPLAY = 2'b10;

always @(posedge slowEnable or posedge rst) begin
    if (rst)
        state <= IDLE;
    else begin
        case(state)
            IDLE: state <= READ;
            READ: state <= DISPLAY;
            DISPLAY: state <= READ;
        endcase
    end
end

// -----------------------------
// LED DATA
// -----------------------------
wire [31:0] ledData;

assign ledData = {
    22'b0,
    ALUControl,
    Branch,
    MemtoReg,
    ALUSrc,
    MemWrite,
    MemRead,
    RegWrite
};

// -----------------------------
// LED MODULE
// -----------------------------
leds led_inst(
    .clk(clk),
    .rst(rst),
    .writeData(ledData),
    .writeEnable(state == DISPLAY),
    .readEnable(1'b0),
    .memAddress(30'b0),
    .readData(),
    .leds(leds)
);

endmodule