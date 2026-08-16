`timescale 1ns / 1ps

module ov7670 (
    // input wire clk,
    input wire rst_n,

    // output xclk,
    output ov7670_RESET,
    output ov7670_PWDN,

    input wire pclk,
    input wire vsync,
    input wire href,
    input wire [7:0] d,

    output      ov7670_scl,
    inout  wire ov7670_sda,

    // bram
    output wire clk_ov,
    output reg we_ov,
    output reg [18:0] waddr_ov,
    output wire dbg_c_state,
    output reg [11:0] wdata_ov
);
    // wire clk_25MHz;

    // assign xclk = clk_25MHz;

    assign ov7670_RESET = 1'b1;
    assign ov7670_PWDN = 1'b0;

    // wire pll_locked;

    // bram
    assign clk_ov = pclk;

    parameter FIRST_BYTE = 1'b0, SECOND_BYTE = 1'b1;

    reg c_state, n_state;
    assign dbg_c_state = c_state;
    reg we_ov_r;
    reg [18:0] waddr_ov_r;
    reg [11:0] wdata_ov_r, data_reg, data_reg_r;

    // clk_wiz_0 U_CLK_WIZ (
    //     .clk_out1(clk_25MHz),
    //     .resetn  (rst_n),
    //     .locked  (),
    //     // .locked  (pll_locked),
    //     .clk_in1 (clk)
    // );

    always @(posedge pclk) begin
        if (!rst_n) begin
            c_state <= FIRST_BYTE;
            we_ov <= 0;
            waddr_ov <= 0;
            wdata_ov <= 0;
            data_reg <= 0;
        end else begin
            c_state <= n_state;
            we_ov <= we_ov_r;
            waddr_ov <= waddr_ov_r;
            wdata_ov <= wdata_ov_r;
            data_reg <= data_reg_r;
        end
    end

    always @(*) begin
        n_state = c_state;
        we_ov_r = we_ov;
        wdata_ov_r = wdata_ov;
        data_reg_r = data_reg;
        case (c_state)
            FIRST_BYTE: begin
                if (!vsync && href) begin
                    we_ov_r = 0;
                    data_reg_r[11:8] = d[7:4];
                    data_reg_r[7:5] = d[2:0];
                    n_state = SECOND_BYTE;
                end
            end
            SECOND_BYTE: begin
                if (!vsync && href) begin
                    data_reg_r[4] = d[7];
                    data_reg_r[3:0] = d[4:1];
                    we_ov_r = 1;
                    wdata_ov_r = data_reg_r;
                    n_state = FIRST_BYTE;
                end
            end
        endcase
    end

    always @(*) begin
        waddr_ov_r = waddr_ov;
        if (vsync) begin
            waddr_ov_r = 0;
        end else if (we_ov) begin
            waddr_ov_r = waddr_ov + 1;
        end
    end

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
