`timescale 1ns / 1ps

module fsm_controller(
    input clk,
    input rst,
    input [15:0] switch_in,
    output reg [15:0] led_out
);

    // States
    parameter WAIT  = 1'b0;
    parameter COUNT = 1'b1;

    reg state;
    reg [15:0] counter;

    // ==========================
    // 1-Second Clock Divider
    // ==========================
    reg [26:0] slow_counter = 0;
    reg tick = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            slow_counter <= 0;
            tick <= 0;
        end
        else if (slow_counter == 100_000_000 - 1) begin
            slow_counter <= 0;
            tick <= 1;           // one clock pulse
        end
        else begin
            slow_counter <= slow_counter + 1;
            tick <= 0;
        end
    end

    // ==========================
    // FSM Logic
    // ==========================
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state   <= WAIT;
            counter <= 0;
            led_out <= 0;
        end
        else begin
            case (state)

                WAIT: begin
                    led_out <= 0;

                    if (switch_in != 0) begin
                        counter <= switch_in;   // capture switch value
                        led_out <= switch_in;   // display immediately
                        state   <= COUNT;
                    end
                end

                COUNT: begin
                    led_out <= counter;

                    if (tick) begin
                        if (counter > 0)
                            counter <= counter - 1;
                        else
                            state <= WAIT;
                    end
                end

            endcase
        end
    end

endmodule