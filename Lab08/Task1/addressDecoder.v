`timescale 1ns/1ps

module addressDecoder(

    input [1:0] deviceSel,

    input writeEnable,
    input readEnable,

    output reg DataMemWrite,
    output reg DataMemRead,

    output reg LEDWrite,

    output reg SwitchRead

);

always @(*)
begin

    DataMemWrite = 0;
    DataMemRead  = 0;
    LEDWrite     = 0;
    SwitchRead   = 0;

    case(deviceSel)

        2'b00:
        begin
            DataMemWrite = writeEnable;
            DataMemRead  = readEnable;
        end

        2'b01:
        begin
            LEDWrite = writeEnable;
        end

        2'b10:
        begin
            SwitchRead = readEnable;
        end

        default:
        begin
        end

    endcase

end

endmodule