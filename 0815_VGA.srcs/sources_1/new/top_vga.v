module top_vga (
    input  wire       clk,
    input  wire       rst_n,
    output wire       h_sync,
    output wire       v_sync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue
);


    wire [9:0] cnt800;
    wire [9:0] cnt525;
    wire [9:0] x;
    wire [9:0] y;
    wire clk_25MHz;
    wire [11:0] test_data;
    wire [16:0] addr;
    wire de;

    wire h_sync_raw, v_sync_raw;

    reg de_r, h_sync_r, v_sync_r;

    assign h_sync = h_sync_r;
    assign v_sync = v_sync_r;

    always @(posedge clk_25MHz or negedge rst_n) begin
        if (!rst_n) begin
            de_r <= 0;
            h_sync_r <= 0;
            v_sync_r <= 0;
        end else begin
            de_r <= de;
            h_sync_r <= h_sync_raw;
            v_sync_r <= v_sync_raw;
        end
    end


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
        .de(de),
        .x(x),
        .y(y),
        .h_sync(h_sync_raw),
        .v_sync(v_sync_raw)
    );

    color_controller U_COLOR_CONT (
        .de(de_r),
        .x(x),
        .y(y),
        .test_data(test_data),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .addr(addr)
    );

    BRAM U_BRAM (
        .clk(clk_25MHz),
        .de(de),
        .addr(addr),
        .test_data(test_data)
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
