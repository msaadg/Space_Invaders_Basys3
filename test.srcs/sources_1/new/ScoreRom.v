`timescale 1ns / 1ps

module ScoreRom(
    input wire [7:0] i_scoreaddr, // (7:0) or 2^8 or 256, need 25 x 8 = 200
    input wire i_clk2,
    output reg [7:0] o_scoredata // (7:0) 8 bit pixel value from Alien3.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] scorememory_array [0:200]; // 8 bit values for 837 pixels of Alien3 (31 x 27)

    initial begin
            $readmemh("score.mem", scorememory_array);
    end

    always @ (posedge i_clk2)
            o_scoredata <= scorememory_array[i_scoreaddr];     
endmodule