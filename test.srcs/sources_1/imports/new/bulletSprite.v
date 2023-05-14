`timescale 1ns / 1ps


module bulletSprite(
input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg BSpriteOn, // 1=on, 0=off
    output reg BSpriteOn2, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Bee.mem
    output wire [7:0] dataout2, // 8 bit pixel value from Bee.mem
    input wire BR, // right button
    input wire BL, // left button
    input wire Pclk, // 25MHz pixel clock
    input wire start,
    input wire reset
    );

    // instantiate BeeRom code
    reg [7:0] address; // 2^10 or 1024, need 34 x 27 = 918
    bulletROM BulletVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
    
    reg [7:0] address2; // 2^10 or 1024, need 34 x 27 = 918
    bulletROM BulletV2Rom (.i_addr(address2),.i_clk2(Pclk),.o_data(dataout2));
            
    // setup character positions and sizes
    reg [9:0] BulletX = 310; // Bee X start position
    reg [8:0] BulletY = 445; // Bee Y start position
    reg [9:0] Bullet2X = 310; // Bee X start position
    reg [8:0] Bullet2Y = 222; // Bee Y start position
    localparam BulletWidth = 10; // Bee width in pixels
    localparam BulletHeight = 20; // Bee height in pixels
    reg [9:0] constX = 310; // Bee X start position
    reg [8:0] constY = 445; // Bee Y start position
  
    
    always @ (posedge Pclk)
    begin
    
    if (reset)
    begin
    constX <= 310;
    constY <= 445;
    end
   

    if (start==0)
    begin
        if (xx==639 && yy==479)
//         if (BulletY > 400)
            //BulletX = startX;
            begin // check for left or right button pressed
                if (BR == 1 && constX<640-26)
                    constX<=constX+3;
                else if (BL == 1 && constX>18)
                    constX<=constX-3;
            end
            
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==BulletX-1 && yy==BulletY)
                    begin
                        address <= 0;
                        BSpriteOn <=1;
                    end
                if ((xx>BulletX-1) && (xx<BulletX+BulletWidth) && (yy>BulletY-1) && (yy<BulletY+BulletHeight))
                    begin
                        address <= address + 1;
                        BSpriteOn <=1;
                    end
                else
                    BSpriteOn <=0;
            end
            
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==Bullet2X-1 && yy==Bullet2Y)
                    begin
                        address2 <= 0;
                        BSpriteOn2 <=1;
                    end
                if ((xx>Bullet2X-1) && (xx<Bullet2X+BulletWidth) && (yy>Bullet2Y-1) && (yy<Bullet2Y+BulletHeight))
                    begin
                        address2 <= address2 + 1;
                        BSpriteOn2 <=1;
                    end
                else
                    BSpriteOn2 <=0;
            end
    end
    end
    
    
    
reg [9:0] delaliens;
reg [9:0] delaliens2;
 always @ (posedge Pclk)
    begin
        // slow down the alien movement / move aliens left or right
        if (xx==639 && yy==479)
            begin
            if (BulletY < 12)
            begin
            BulletY <= constY;
            BulletX <= constX;
            end
            else
              begin
                delaliens<=delaliens+1;
                if (delaliens>1)
                    begin
                        delaliens<=0;
//                        if (Adir==1)
//                            begin
                                BulletY<=BulletY-10;
                    end
                   end
                  end
                  
         if (xx==639 && yy==479)
            begin
            if (Bullet2Y < 12)
            begin
            Bullet2Y <= constY;
            Bullet2X <= constX;
            end
            else
              begin
                delaliens2<=delaliens2+1;
                if (delaliens2>1)
                    begin
                        delaliens2<=0;
//                        if (Adir==1)
//                            begin
                                Bullet2Y<=Bullet2Y-10;
                    end
                   end
                  end
    end

endmodule
