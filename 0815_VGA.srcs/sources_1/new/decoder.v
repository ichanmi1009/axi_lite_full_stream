`timescale 1ns / 1ps
module decoder (
    input wire [$clog2(800)-1:0] h_count,
    input wire [$clog2(525)-1:0] v_count,
    output de,
    output [$clog2(800)-1:0] x,
    output [$clog2(525)-1:0] y,
    output h_sync,
    output v_sync
);
    assign x = h_count;
    assign y = v_count;
    assign de = (h_count < 640) && (v_count < 480) ? 1'b1 : 1'b0;
    assign h_sync = ((h_count >= 656) && (h_count < 752)) ? 1'b0 : 1'b1;
    assign v_sync = ((v_count >= 490) && (v_count < 492)) ? 1'b0 : 1'b1;
endmodule
