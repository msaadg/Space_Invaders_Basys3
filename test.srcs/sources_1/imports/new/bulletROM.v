`timescale 1ns / 1ps

module bulletROM(
    input wire [7:0] i_addr, // (7:0) or 2^8 or 256, need 10 x 20 = 200
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Bee.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:199]; // 8 bit values for 918 pixels of Bee (34 x 27)

    initial begin
            $readmemh("bullet_blackbg.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  
endmodule
