`timescale 1ns / 1ps

module BRAM (
    input  wire        clk_ov,
    input  wire        clk_rgb,
    input  wire        we_ov,
    input  wire        re_rgb,
    input  wire [18:0] waddr_ov,
    input  wire [18:0] raddr_rgb,
    input  wire [11:0] wdata_ov,
    output reg  [11:0] rdata_rgb
);
    (* ram_style = "block" *)
    reg [11:0] mem[0:(640*480)-1];
    // initial begin
    //     $readmemh("test_320x240.mem", test_mem);
    // end

    always @(posedge clk_ov) begin
        if (we_ov) begin
            mem[waddr_ov] <= wdata_ov;
        end
    end

    always @(posedge clk_rgb) begin
        if (re_rgb) begin
            rdata_rgb <= mem[raddr_rgb];
        end
    end

endmodule

// module BRAM (
//     input  wire        clk,
//     input  wire        de,
//     input  wire [16:0] addr,
//     output reg  [11:0] test_data
// );
//     (* ram_style = "block" *)
//     reg [11:0] test_mem[0:(320*240)-1];
//     initial begin
//         $readmemh("test_320x240.mem", test_mem);
//     end

//     always @(posedge clk) begin
//         if (de) begin
//             test_data <= test_mem[addr];
//         end
//     end

// endmodule
