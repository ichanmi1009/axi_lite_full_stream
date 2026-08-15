`timescale 1ns / 1ps

module counter (
    // input wire clk,
    input wire rst_n,
    // input wire tick,
    input wire clk_25MHz,
    output reg [$clog2(800)-1:0] cnt800,
    output reg [$clog2(525)-1:0] cnt525
);
    always @(posedge clk_25MHz or negedge rst_n) begin
        if (!rst_n) begin
            cnt800 <= 0;
            cnt525 <= 0;
        // end else if (tick) begin
        end else begin
            cnt800 <= cnt800 + 1;
            if (cnt800 == 799) begin
                cnt800 <= 0;
                cnt525 <= cnt525 + 1;
                if (cnt525 == 524) begin
                    cnt525 <= 0;
                end
            end
        end
    end
endmodule



