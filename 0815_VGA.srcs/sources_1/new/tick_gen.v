`timescale 1ns / 1ps

module tick_gen #(
    parameter SYS_FREQ  = 100_000_000,
    parameter TICK_FREQ = 25000000
) (
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);

    localparam COUNT_FREQ = SYS_FREQ / TICK_FREQ;
    localparam COUNT_WIDTH = $clog2(COUNT_FREQ);

    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            tick  <= 0;
        end else begin
            if (count == COUNT_FREQ - 1) begin
                tick  <= 1;
                count <= 0;
            end else begin
                tick  <= 0;
                count <= count + 1;
            end
        end
    end
endmodule
