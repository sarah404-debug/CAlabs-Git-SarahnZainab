
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

//    // Loop protection (program size = 6 instructions = 24 bytes)
//    wire [31:0] safePC4;
//    assign safePC4 = (pc >= 32'd24) ? 32'd0 : pc4;

//    mux2 PCMux (
//        .in0(safePC4),
//        .in1(branchAddr),
//        .sel(PCSrc),
//        .out(nextPC)
//    );

//    // ================= MEMORY (DISABLED FOR DEMO) =================
//    wire [31:0] readData;
//    assign readData = 32'b0;

//    // ================= WRITEBACK =================
//    assign writeData = (memToReg) ? readData : aluResult;

//    // ================= LED DEMO =================
//    assign leds[0] = RF.regs[3][0];          // SLT result (x3)
//    assign leds[1] = branch & branch_cond;   // BNE taken
//    assign leds[2] = RF.regs[5][0];          // XORI result (x5)
//    assign leds[15:3] = 13'b0;

//    // ================= 7-SEG DISPLAY =================
//    wire [15:0] displayData;

//    // Show: x5 x3 x2 x1
//    assign displayData = {
//        RF.regs[5][3:0],   // leftmost digit
//        RF.regs[3][3:0],
//        RF.regs[2][3:0],
//        RF.regs[1][3:0]    // rightmost digit
//    };

//    sevenSegDriver SSD (
//        .clk(clk),
//        .data(displayData),
//        .seg(seg),
//        .an(an)
//    );

//endmodule











//`timescale 1ns / 1ps

//module TopLevelProcessor(
//    input clk,
//    input reset,
//    input [15:0] switches,
//    output [15:0] leds,
//    output [6:0] seg,
//    output [3:0] an
//);

//    // ================= DATAPATH WIRES =================
//    wire [31:0] pc, nextPC, pc4, branchAddr;
//    wire [31:0] instruction, imm;
//    wire [31:0] readData1, readData2, writeData;
//    wire [31:0] aluInput2, aluResult, readData;
//    wire [3:0]  aluControlSignal;
//    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch, zero;
//    wire branch_cond, PCSrc;

//    // ================= PC & INSTRUCTION FETCH =================
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

//    instructionMemory InstMem (
//        .instAddress(pc),
//        .instruction(instruction)
//    );

//    // ================= CONTROL UNIT =================
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

//    // ================= REGISTER FILE & IMM GEN =================
//    immGen IG (
//        .instr(instruction),
//        .imm(imm)
//    );

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

//    // ================= ALU & BRANCH LOGIC =================
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

//    branchAdder AddImm (
//        .pc(pc),
//        .imm(imm),
//        .branchAddr(branchAddr)
//    );

//    assign branch_cond = (instruction[14:12] == 3'b000) ? zero : 
//                         (instruction[14:12] == 3'b001) ? ~zero : 1'b0;

//    assign PCSrc = branch & branch_cond;

//    // Program Loop (Reset after 6 instructions / 20 bytes offset)
//    assign nextPC = (PCSrc) ? branchAddr : (pc >= 32'd20) ? 32'd0 : pc4;

//    // ================= WRITEBACK =================
//    assign readData = 32'b0; // Memory data read disabled for demo
//    assign writeData = (memToReg) ? readData : aluResult;

//    // ================= HARDWARE VISIBILITY (TASK B VERIFICATION) =================
    
//    // LED 0: SLT Result (x3). Should be ON because (5 < 10) is true.
//    assign leds[0] = RF.regs[3][0];

//    // LED 1: Branch Status. Lights up only when BNE is 'Taken'.
//    assign leds[1] = PCSrc;

//    // LED 15-2: LUI High Bits (x5). Shows the upper bits of the immediate.
//    // Mapping the upper bits ensures the LEDs turn ON since LUI clears the bottom 12 bits.
//    assign leds[15:2] = RF.regs[5][31:18];

//    // 7-SEGMENT: Displays values of registers involved in Task B.
//    // Digit 1 (Left): x5 High Nibble (LUI result) -> Will show '1' from 0x12345000
//    // Digit 2: x3 (SLT result) -> Will show '1'
//    // Digit 3: x2 (ADDI result) -> Will show 'A' (value 10)
//    // Digit 4 (Right): x1 (ADDI result) -> Will show '5'
//    wire [15:0] hardwareDisplayData;
//    assign hardwareDisplayData = {
//        RF.regs[5][31:28], 
//        RF.regs[3][3:0],   
//        RF.regs[2][3:0],   
//        RF.regs[1][3:0]    
//    };

//    sevenSegDriver SSD (
//        .clk(clk),
//        .data(hardwareDisplayData),
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
    wire slow_clk;

    clk_divider div (
        .clk(clk),
        .slow_clk(slow_clk)
    );

    // ================= DATAPATH WIRES =================
    wire [31:0] pc, nextPC, pc4, branchAddr;
    wire [31:0] instruction, imm;
    wire [31:0] readData1, readData2, writeData;
    wire [31:0] aluInput2, aluResult;
    wire [3:0]  aluControlSignal;
    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch, zero;
    wire branch_cond, PCSrc;

    // ================= PC (SLOWED DOWN) =================
    ProgramCounter PC_Unit (
        .clk(slow_clk),   // ? ONLY CHANGE
        .reset(reset),
        .nextPC(nextPC),
        .pc(pc)
    );

    pcAdder Add4 (
        .pc(pc),
        .pc4(pc4)
    );

    // ================= INSTRUCTION =================
    instructionMemory InstMem (
        .instAddress(pc),
        .instruction(instruction)
    );

    // ================= CONTROL =================
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

    // ================= IMM =================
    immGen IG (
        .instr(instruction),
        .imm(imm)
    );

    // ================= REGISTER FILE =================
    RegisterFile RF (
        .clk(slow_clk),   // optional but recommended
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

    assign branch_cond =
        (instruction[14:12] == 3'b000) ? zero :
        (instruction[14:12] == 3'b001) ? ~zero :
        1'b0;

    assign PCSrc = branch & branch_cond;

    // Loop program (6 instructions)
    assign nextPC = (PCSrc) ? branchAddr :
                    (pc >= 32'd20) ? 32'd0 :
                    pc4;

    // ================= WRITEBACK =================
    assign writeData = aluResult;

    // ================= TASK B OUTPUT =================

    // LED 0: SLT result
    assign leds[0] = RF.regs[3][0];

    // LED 1: BNE taken
    assign leds[1] = PCSrc;

    // LED[15:2]: LUI upper bits
    assign leds[15:2] = RF.regs[5][31:18];

    // ================= 7-SEG =================
    wire [15:0] display;

    assign display = {
        RF.regs[5][31:28],  // LUI
        RF.regs[3][3:0],    // SLT
        RF.regs[2][3:0],    // x2
        RF.regs[1][3:0]     // x1
    };

    sevenSegDriver SSD (
        .clk(clk),   // keep fast for display multiplexing
        .data(display),
        .seg(seg),
        .an(an)
    );

endmodule