`timescale 1ns / 1ps

module HighRom(
    input wire [8:0] i_highaddr, // (8:0) or 2^9 or 512, need 25 x 16 = 400
    input wire i_clk2,
    output reg [7:0] o_highdata // (7:0) 8 bit pixel value from Alien3.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] highmemory_array [0:400]; // 8 bit values for 837 pixels of Alien3 (31 x 27)

    initial begin
            $readmemh("high.mem", highmemory_array);
    end

    always @ (posedge i_clk2)
            o_highdata <= highmemory_array[i_highaddr];     
endmodule