`timescale 1ns / 1ps

module color_controller (
    input  wire        de,
    input  wire [ 9:0] x,
    input  wire [ 9:0] y,
    input  wire [11:0] bram_data,
    output reg  [ 3:0] vgaRed,
    output reg  [ 3:0] vgaGreen,
    output reg  [ 3:0] vgaBlue,
    output      [18:0] addr
);
    // assign addr = (de == 1) ? (y >> 1) * 320 + (x >> 1) : 0;
    assign addr = y * 640 + x;


    always @(*) begin
        vgaRed   = 0;
        vgaGreen = 0;
        vgaBlue  = 0;
        if (de) begin
            vgaRed   = bram_data[11:8];
            vgaGreen = bram_data[7:4];
            vgaBlue  = bram_data[3:0];
        end
    end
endmodule
