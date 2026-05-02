//`timescale 1ns / 1ps

//module TopLevelProcessor(
//    input clk,
//    input reset,
//    input [15:0] switches,
//    output [15:0] leds,     // LED[14:0] = Lower 16 bits of Data, LED[15] = Branch Taken
//    output [6:0] seg,
//    output [3:0] an
//);

//    // ================= PC =================
//    wire [31:0] pc, nextPC, pc4;

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

//    // ================= MEMORY / IO =================
//    wire [31:0] readData;
//    wire [15:0] led_val;

//    addressDecoderTop IO_System (
//        .clk(clk),
//        .rst(reset),
//        .address(aluResult),
//        .readEnable(memRead),
//        .writeEnable(memWrite),
//        .writeData(readData2),
//        .switches(switches),
//        .readData(readData),
//        .leds(led_val)
//    );

//    // ================= HARDWARE OUTPUT MAPPING =================
//    // Mapping LED[15] to show branch status per instruction guidelines
//    // LED[14:0] shows the lower 15 bits of the memory-mapped value
//    assign leds[14:0] = led_val[14:0];
//    assign leds[15]   = PCSrc;

//    // ================= CONTROL FLAGS =================
//    wire isJAL  = (instruction[6:0] == 7'b1101111);
//    wire isJALR = (instruction[6:0] == 7'b1100111);
//    wire isLUI  = (instruction[6:0] == 7'b0110111);

//    // ================= BRANCH =================
//    wire [31:0] branchAddr;

//    branchAdder AddImm (
//        .pc(pc),
//        .imm(imm),
//        .branchAddr(branchAddr)
//    );

//    wire branch_cond;

//    assign branch_cond =
//        (instruction[14:12] == 3'b000) ? zero :          // BEQ
//        (instruction[14:12] == 3'b001) ? ~zero :         // BNE
//        (instruction[14:12] == 3'b100) ? aluResult[31] : // BLT
//        1'b0;

//    wire PCSrc = branch & branch_cond;

//    // ================= PC UPDATE =================
//    assign nextPC =
//        (isJAL)  ? (pc + imm) :
//        (isJALR) ? ((readData1 + imm) & 32'hFFFFFFFE) :
//        (PCSrc)  ? branchAddr :
//                   pc4;

//    // ================= WRITEBACK =================
//    assign writeData =
//        (isLUI)           ? imm :
//        (isJAL || isJALR) ? (pc + 4) :
//        (memToReg)        ? readData :
//                            aluResult;

//    // ================= 7-SEG DISPLAY =================
//    // Showing lower 16 bits on the display
//    sevenSegDriver SSD (
//        .clk(clk),
//        .data(led_val),
//        .seg(seg),
//        .an(an)
//    );

//endmodule



`timescale 1ns / 1ps

module TopLevelProcessor(
    input clk,
    input reset,
    input [15:0] switches,
    output [15:0] leds,     // LED[14:0] = Lower 16 bits of Data, LED[15] = Branch Taken
    output [6:0] seg,
    output [3:0] an
);

    // ================= CLOCK DIVIDER =================
    // Slows down the Program Counter so the countdown is visible
    wire slow_en;
    
    clk_divider divider (
        .clk(clk),
        .rst(reset),
        .slowEnable(slow_en)
    );

    // ================= PC =================
    wire [31:0] pc, nextPC, pc4;

    ProgramCounter PC_Unit (
        .clk(clk),
        .reset(reset),
        .en(slow_en),        // Gating PC update with slow clock enable
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

    // ================= MEMORY / IO =================
    wire [31:0] readData;
    wire [15:0] led_val;

    addressDecoderTop IO_System (
        .clk(clk),
        .rst(reset),
        .address(aluResult),
        .readEnable(memRead),
        .writeEnable(memWrite),
        .writeData(readData2),
        .switches(switches),
        .readData(readData),
        .leds(led_val)
    );

    // ================= HARDWARE OUTPUT MAPPING =================
    // Mapping LED[15] to show branch status per instruction guidelines
    assign leds[14:0] = led_val[14:0];
    assign leds[15]   = PCSrc;

    // ================= CONTROL FLAGS =================
    wire isJAL  = (instruction[6:0] == 7'b1101111);
    wire isJALR = (instruction[6:0] == 7'b1100111);
    wire isLUI  = (instruction[6:0] == 7'b0110111);

    // ================= BRANCH =================
    wire [31:0] branchAddr;

    branchAdder AddImm (
        .pc(pc),
        .imm(imm),
        .branchAddr(branchAddr)
    );

    wire branch_cond;

    assign branch_cond =
        (instruction[14:12] == 3'b000) ? zero :           // BEQ
        (instruction[14:12] == 3'b001) ? ~zero :          // BNE
        (instruction[14:12] == 3'b100) ? aluResult[31] :  // BLT
        1'b0;

    wire PCSrc = branch & branch_cond;

    // ================= PC UPDATE =================
    assign nextPC =
        (isJAL)  ? (pc + imm) :
        (isJALR) ? ((readData1 + imm) & 32'hFFFFFFFE) :
        (PCSrc)  ? branchAddr :
                   pc4;

    // ================= WRITEBACK =================
    assign writeData =
        (isLUI)           ? imm :
        (isJAL || isJALR) ? (pc + 4) :
        (memToReg)        ? readData :
                            aluResult;

    // ================= 7-SEG DISPLAY =================
    sevenSegDriver SSD (
        .clk(clk),
        .data(led_val),
        .seg(seg),
        .an(an)
    );

endmodule