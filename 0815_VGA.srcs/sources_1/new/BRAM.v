`timescale 1ns / 1ps

module BRAM (
    input  wire        clk,
    input  wire        de,
    input  wire [16:0] addr,
    output reg  [11:0] test_data
);
    (* ram_style = "block" *)
    reg [11:0] test_mem[0:(320*240)-1];
    initial begin
        $readmemh("test_320x240.mem", test_mem);
    end

    always @(posedge clk) begin
        if (de) begin
            test_data <= test_mem[addr];
        end
    end

endmodule
