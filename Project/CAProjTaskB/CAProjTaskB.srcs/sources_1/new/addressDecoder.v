`timescale 1ns/1ps
module addressDecoder(
    input  [1:0] deviceSel,
    input        writeEnable,
    input        readEnable,
    output reg   DataMemWrite,
    output reg   DataMemRead,
    output reg   LEDWrite,
    output reg   SwitchRead
);

always @(*) begin
    // default all signals off
    DataMemWrite = 0;
    DataMemRead  = 0;
    LEDWrite     = 0;
    SwitchRead   = 0;

    case (deviceSel)
        2'b00: begin                          // Data Memory (0-511)
            DataMemWrite = writeEnable;
            DataMemRead  = readEnable;
        end
        2'b01: LEDWrite   = writeEnable;      // LEDs (512-767)
        2'b10: SwitchRead = readEnable;       // Switches (768-1023)
        // 2'b11: unused
    endcase
end

endmodule