`timescale 1ns / 1ps

module tb_top ();

    reg        clk;
    reg        rst_n;
    // reg  [11:0] sw;
    wire       h_sync;
    wire       v_sync;
    wire [3:0] vgaRed;
    wire [3:0] vgaGreen;
    wire [3:0] vgaBlue;

    top_vga U_TOP_VGA (
        .clk     (clk),
        .rst_n   (rst_n),
        // .sw      (sw),
        .h_sync  (h_sync),
        .v_sync  (v_sync),
        .vgaRed  (vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue (vgaBlue)
    );


    always #5 clk = ~clk;
    initial begin
        clk   = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // sw[3:0]  = 4'b1111;
        // sw[7:4]  = 4'b1111;
        // sw[11:8] = 4'b1111;
    end




endmodule
