
//`timescale 1ns / 1ps

//module TopLevelProcessor(
//    input clk,
//    input reset,
//    input [15:0] switches,
//    output [15:0] leds,
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
//    // FIXED: led_val wire captures LED output cleanly - no double driver
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
//        .leds(led_val)          // FIXED: captured into led_val wire
//    );

//    assign leds = led_val;      // FIXED: single clean driver for leds port

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
//        (instruction[14:12] == 3'b100) ? aluResult[31] : // BLT (FIXED: sign bit, not ==1)
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
//    // FIXED: now shows actual LED value from memory-mapped output
//    sevenSegDriver SSD (
//        .clk(clk),
//        .data(led_val),     // FIXED: was RF.regs[11] which is never written
//        .seg(seg),
//        .an(an)
//    );

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

    // ================= CLOCK DIVIDER =================
    wire slowEnable;

    clk_divider div (
        .clk(clk),
        .slowEnable(slowEnable)
    );

    // ================= PC =================
    wire [31:0] pc, nextPC, pc4;

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

    // ================= SLOW LED UPDATE =================
    reg [15:0] led_reg;

    always @(posedge clk) begin
        if (slowEnable)
            led_reg <= led_val;
    end

    assign leds = led_reg;

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
        (instruction[14:12] == 3'b000) ? zero :
        (instruction[14:12] == 3'b001) ? ~zero :
        (instruction[14:12] == 3'b100) ? aluResult[31] :
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
        .data(led_reg),   // slowed display
        .seg(seg),
        .an(an)
    );

endmodule