//`timescale 1ns / 1ps

//module TopLevelProcessor(
//    input clk,
//    input reset,
//    input [15:0] switches,
//    output [15:0] leds
//);

//    // ================= PC =================
//    wire [31:0] pc, nextPC, pc4, branchAddr;

//    ProgramCounter PC_Unit (
//        .clk(clk),
//        .reset(reset),
//        .nextPC(nextPC),
//        .pc(pc)
//    );

//    pcAdder Add4 (
//        .pc(pc),
//        .pc4(pc4)
//    );

//    // ================= INSTRUCTION =================
//    wire [31:0] instruction;

//    instructionMemory InstMem (
//        .instAddress(pc),
//        .instruction(instruction)
//    );

//    // ================= CONTROL =================
//    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch;
//    wire [3:0] aluControlSignal;

//    control_top CU (
//        .opcode(instruction[6:0]),
//        .funct3(instruction[14:12]),
//        .funct7(instruction[31:25]),
//        .regWrite(regWrite),
//        .memRead(memRead),
//        .memWrite(memWrite),
//        .aluSrc(aluSrc),
//        .memToReg(memToReg),
//        .branch(branch),
//        .aluControl(aluControlSignal)
//    );

//    // ================= IMMEDIATE =================
//    wire [31:0] imm;

//    immGen IG (
//        .instr(instruction),
//        .imm(imm)
//    );

//    // ================= REGISTER FILE =================
//    wire [31:0] readData1, readData2;
//    wire [31:0] writeData;

//    RegisterFile RF (
//        .clk(clk),
//        .rst(reset),
//        .writeEnable(regWrite),
//        .rs1(instruction[19:15]),
//        .rs2(instruction[24:20]),
//        .rd(instruction[11:7]),
//        .writeData(writeData),
//        .readData1(readData1),
//        .readData2(readData2)
//    );

//    // ================= ALU =================
//    wire [31:0] aluInput2;
//    wire [31:0] aluResult;
//    wire zero;

//    mux2 ALUMux (
//        .in0(readData2),
//        .in1(imm),
//        .sel(aluSrc),
//        .out(aluInput2)
//    );

//    ALU MainALU (
//        .A(readData1),
//        .B(aluInput2),
//        .ALUControl(aluControlSignal),
//        .ALUResult(aluResult),
//        .Zero(zero)
//    );

//    // ================= BRANCH =================
//    branchAdder AddImm (
//        .pc(pc),
//        .imm(imm),
//        .branchAddr(branchAddr)
//    );

//    wire branch_cond;

//    assign branch_cond =
//        (instruction[14:12] == 3'b000) ? zero :     // BEQ
//        (instruction[14:12] == 3'b001) ? ~zero :    // BNE
//        1'b0;

//    wire PCSrc = branch & branch_cond;

//    // loop program (6 instructions ? 24 bytes)
//    wire [31:0] safePC4;
//    assign safePC4 = (pc >= 32'd24) ? 32'd0 : pc4;

//    mux2 PCMux (
//        .in0(safePC4),
//        .in1(branchAddr),
//        .sel(PCSrc),
//        .out(nextPC)
//    );

//    // ================= MEMORY + IO =================
//    wire [31:0] readData;

//    addressDecoderTop IO_System (
//        .clk(clk),
//        .rst(reset),
//        .address(aluResult),
//        .readEnable(memRead),
//        .writeEnable(memWrite),
//        .writeData(readData2),
//        .switches(switches),
//        .readData(readData),
//        .leds(leds)
//    );

//    // ================= WRITEBACK (? FIXED) =================
//    reg [31:0] writeData_reg;

//    assign writeData = (memToReg) ? readData : aluResult;


//endmodule

`timescale 1ns / 1ps

module TopLevelProcessor(
    input clk,
    input reset,
    input [15:0] switches,
    output [15:0] leds,
    output [6:0] seg,
    output [3:0] an
);

    // ================= PC =================
    wire [31:0] pc, nextPC, pc4, branchAddr;

    ProgramCounter PC_Unit (
        .clk(clk),
        .reset(reset),
        .nextPC(nextPC),
        .pc(pc)
    );

    pcAdder Add4 (
        .pc(pc),
        .pc4(pc4)
    );

    // ================= INSTRUCTION =================
    wire [31:0] instruction;

    instructionMemory InstMem (
        .instAddress(pc),
        .instruction(instruction)
    );

    // ================= CONTROL =================
    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch;
    wire [3:0] aluControlSignal;

    control_top CU (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .regWrite(regWrite),
        .memRead(memRead),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .memToReg(memToReg),
        .branch(branch),
        .aluControl(aluControlSignal)
    );

    // ================= IMMEDIATE =================
    wire [31:0] imm;

    immGen IG (
        .instr(instruction),
        .imm(imm)
    );

    // ================= REGISTER FILE =================
    wire [31:0] readData1, readData2;
    wire [31:0] writeData;

    RegisterFile RF (
        .clk(clk),
        .rst(reset),
        .writeEnable(regWrite),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    // ================= ALU =================
    wire [31:0] aluInput2;
    wire [31:0] aluResult;
    wire zero;

    mux2 ALUMux (
        .in0(readData2),
        .in1(imm),
        .sel(aluSrc),
        .out(aluInput2)
    );

    ALU MainALU (
        .A(readData1),
        .B(aluInput2),
        .ALUControl(aluControlSignal),
        .ALUResult(aluResult),
        .Zero(zero)
    );

    // ================= BRANCH =================
    branchAdder AddImm (
        .pc(pc),
        .imm(imm),
        .branchAddr(branchAddr)
    );

    wire branch_cond;

    assign branch_cond =
        (instruction[14:12] == 3'b000) ? zero :     // BEQ
        (instruction[14:12] == 3'b001) ? ~zero :    // BNE
        1'b0;

    wire PCSrc = branch & branch_cond;

    // Loop protection (program size = 6 instructions = 24 bytes)
    wire [31:0] safePC4;
    assign safePC4 = (pc >= 32'd24) ? 32'd0 : pc4;

    mux2 PCMux (
        .in0(safePC4),
        .in1(branchAddr),
        .sel(PCSrc),
        .out(nextPC)
    );

    // ================= MEMORY (DISABLED FOR DEMO) =================
    wire [31:0] readData;
    assign readData = 32'b0;

    // ================= WRITEBACK =================
    assign writeData = (memToReg) ? readData : aluResult;

    // ================= LED DEMO =================
    assign leds[0] = RF.regs[3][0];          // SLT result (x3)
    assign leds[1] = branch & branch_cond;   // BNE taken
    assign leds[2] = RF.regs[5][0];          // XORI result (x5)
    assign leds[15:3] = 13'b0;

    // ================= 7-SEG DISPLAY =================
    wire [15:0] displayData;

    // Show: x5 x3 x2 x1
    assign displayData = {
        RF.regs[5][3:0],   // leftmost digit
        RF.regs[3][3:0],
        RF.regs[2][3:0],
        RF.regs[1][3:0]    // rightmost digit
    };

    sevenSegDriver SSD (
        .clk(clk),
        .data(displayData),
        .seg(seg),
        .an(an)
    );

endmodule