module top_vga (
    input  wire       clk,
    input  wire       rst_n,
    output wire       h_sync,
    output wire       v_sync,
    input  wire [7:0] d,
    input  wire       href,
    input  wire       pclk,
    input  wire       vsync,
    output      [3:0] vgaRed,
    output      [3:0] vgaGreen,
    output      [3:0] vgaBlue,
    output            xclk,
    output            ov7670_RESET,
    output            ov7670_PWDN,
    output            ov7670_scl,
    inout  wire       ov7670_sda
);

    wire [9:0] cnt800;
    wire [9:0] cnt525;
    wire [9:0] x;
    wire [9:0] y;
    wire clk_25MHz;  // clk_rgb
    assign xclk = clk_25MHz;

    wire [11:0] rdata_rgb;
    wire [18:0] raddr_rgb;
    wire re_rgb;

    // ov7670
    wire vsync_ov;
    wire href_ov;
    wire [7:0] d_ov;
    wire scl_ov;
    wire sda_ov;

    // ov7670 -> bram
    wire clk_ov;
    wire we_ov;
    wire [18:0] waddr_ov;
    wire [11:0] wdata_ov;

    // syncronizer
    wire h_sync_raw, v_sync_raw;
    reg re_r, h_sync_r, v_sync_r;
    assign h_sync = h_sync_r;
    assign v_sync = v_sync_r;

    wire dbg_c_state;

    always @(posedge clk_25MHz or negedge rst_n) begin
        if (!rst_n) begin
            re_r <= 0;
            h_sync_r <= 0;
            v_sync_r <= 0;
        end else begin
            re_r <= re_rgb;
            h_sync_r <= h_sync_raw;
            v_sync_r <= v_sync_raw;
        end
    end

    ila_0 U_ILA_0 (
        .clk(pclk),
        // .probe0(d),
        // .probe1(xclk),
        // .probe2(pclk),
        // .probe3(vsync),
        // .probe4(href),
        // .probe1(h_sync),
        // .probe2(v_sync),
        .probe0(d),
        .probe1(vsync),
        .probe2(href),
        .probe3(xclk),
        .probe4(pclk)
        // .probe1(re_rgb),
        // .probe2(rdata_rgb)
    );

    clk_wiz_0 U_CLK_WIZ (
        .clk_out1(clk_25MHz),
        .resetn  (rst_n),
        .locked  (),
        .clk_in1 (clk)
    );

    counter U_COUNTER (
        .rst_n(rst_n),
        .clk_25MHz(clk_25MHz),
        .cnt800(cnt800),
        .cnt525(cnt525)
    );

    decoder U_DECODER (
        .h_count(cnt800),
        .v_count(cnt525),
        .de(re_rgb),
        .x(x),
        .y(y),
        .h_sync(h_sync_raw),
        .v_sync(v_sync_raw)
    );

    color_controller U_COLOR_CONT (
        .de(re_r),
        .x(x),
        .y(y),
        .bram_data(rdata_rgb),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .addr(raddr_rgb)
    );

    BRAM U_BRAM (
        .clk_ov(clk_ov),
        .clk_rgb(clk_25MHz),
        .we_ov(we_ov),
        .re_rgb(re_rgb),
        .waddr_ov(waddr_ov),
        .raddr_rgb(raddr_rgb),
        .wdata_ov(wdata_ov),
        .rdata_rgb(rdata_rgb)
    );

    ov7670 U_OV7670 (
        // .clk(clk),
        .rst_n(rst_n),
        // .xclk(xclk),
        .ov7670_RESET(ov7670_RESET),
        .ov7670_PWDN(ov7670_PWDN),
        .pclk(pclk),
        .vsync(vsync),
        .href(href),
        .d(d),
        .ov7670_scl(scl_ov),
        .ov7670_sda(sda_ov),
        // bram
        .clk_ov(clk_ov),
        .we_ov(we_ov),
        .waddr_ov(waddr_ov),
        // .dbg_c_state(dbg_c_state),
        .wdata_ov(wdata_ov)
    );

endmodule

// module top_vga (
//     input  wire       clk,
//     input  wire       rst_n,
//     // input  wire [11:0] sw,
//     output wire       h_sync,
//     output wire       v_sync,
//     output wire [3:0] vgaRed,
//     output wire [3:0] vgaGreen,
//     output wire [3:0] vgaBlue
// );
//     // wire tick;
//     wire [9:0] cnt800;
//     wire [9:0] cnt525;
//     wire [9:0] x;
//     wire [9:0] y;
//     wire clk_25MHz;
//     wire [11:0] test_data;
//     wire [18:0] addr;
//     wire de;

//     reg de_r, h_sync_r, v_sync_r;

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             de_r <= 0;
//             h_sync_r <= 0;
//             v_sync_r <= 0;
//         end else begin
//             de_r <= de;
//             h_sync_r <= h_sync;
//             v_sync_r <= v_sync;
//         end
//     end


//     // tick_gen U_TICK_GEN (
//     //     .clk  (clk),
//     //     .rst_n(rst_n),
//     //     .tick (tick)
//     // );

//     clk_wiz_0 U_CLK_WIZ (
//         // Clock out ports
//         .clk_out1(clk_25MHz),
//         // Status and control signals
//         .resetn(rst_n),
//         .locked  (), // clock이 정상적으로 생성되었는지 확인하는 것
//         // Clock in ports
//         .clk_in1(clk)
//     );


//     counter U_COUNTER (
//         // .clk(clk),
//         .rst_n(rst_n),
//         .clk_25MHz(clk_25MHz),
//         .cnt800(cnt800),
//         .cnt525(cnt525)
//     );

//     decoder U_DECODER (
//         .h_count(cnt800),
//         .v_count(cnt525),
//         .de(de),
//         .x(x),
//         .y(y),
//         .h_sync(h_sync),
//         .v_sync(v_sync)
//     );

//     color_controller U_COLOR_CONT (
//         // .sw(sw),
//         .de(de_r),
//         .x(x),
//         .y(y),
//         .test_data(test_data),
//         .vgaRed(vgaRed),
//         .vgaGreen(vgaGreen),
//         .vgaBlue(vgaBlue),
//         .addr(addr)
//     );

//     BRAM U_BRAM (
//         .clk(clk_25MHz),
//         .de(de),
//         .addr(addr),
//         .test_data(test_data)
//     );

// endmodule
