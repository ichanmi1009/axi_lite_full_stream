`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/13 19:36:59
// Design Name: 
// Module Name: top_ov7670
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_ov7670 (
    input wire clk,
    input wire rst_n,

    output xclk,
    output ov7670_RESET,
    output ov7670_PWDN,

    input wire pclk,
    input wire vsync,
    input wire href,
    input wire [7:0] d,

    output wire ov7670_scl,
    inout  wire ov7670_sda
);
    wire clk_25MHz;

    assign xclk = clk_25MHz;

    assign ov7670_RESET = 1'b1;
    assign ov7670_PWDN = 1'b0;

    wire pll_locked;

    clk_wiz_0 U_CLK_WIZ (
        .clk_out1(clk_25MHz),
        .resetn  (rst_n),
        .locked  (),
        // .locked  (pll_locked),
        .clk_in1 (clk)
    );


    // ila_0 U_ILA_0 (
    //     // Do not use xclk itself as the ILA sampling clock: sampling a clock
    //     // on its own rising edge only captures one logic level.  Use the
    //     // 125 MHz board clock so the generated 25 MHz xclk is observable.
    //     .clk(clk),
    //     .probe0(d),
    //     .probe1(xclk),
    //     .probe2(pclk),
    //     .probe3(vsync),
    //     .probe4(href),
    //     .probe5(pll_locked)
    // );

endmodule
