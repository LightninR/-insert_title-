`timescale 1ns / 1ps
/****************************** C E C S  3 6 0 ******************************
 * 
 * File Name:  top_level.v
 *
 * Created by       Jordan Mark Gammad on 4/15/18.
 * Copyright © 2018 Jordan Mark Gammad. All rights reserved.
 *
 * In submitting this file for class work at CSULB
 * I am confirming that this is my work and the work
 * of no one else. In submitting this code I acknowledge that
 * plagiarism in student project work is subject to dismissal
 * from the class.
 *         
 ****************************************************************************/
module top_level(clk_100MHz, rst, sw, hsync, vsync, rgb);
    input         clk_100MHz, rst;
    input  [1:0]  sw;
   output         hsync, vsync;
   output  [11:0] rgb;
     wire         pixel_tick, rst_s, video;
     wire  [9:0]  pixel_x, pixel_y;
     wire  [11:0]  rgb_next;
     reg   [11:0]  rgb_reg;
     
   // Asynchronous In Synchronous Out
   aiso
      // aiso port list format:
      AISO(.clk(clk_100MHz), // clk
           .rst(rst),        // rst
           .rst_s(rst_s));   // rst_s
           
   // Video Graphics Array
   vga
      // vga port list format:
      VGA(.clk_100MHz(clk_100MHz), // clk
          .rst(rst_s),             // rst
          .hsync(hsync),           // hsync
          .vsync(vsync),           // vsync
          .video(video),           // video
          .pixel_tick(pixel_tick), // pixel_tick
          .pixel_x(pixel_x),       // pixel_x
          .pixel_y(pixel_y));      // pixel_y
         
   // Pixel Generator
   vga_animate
      // pixel_generator port list format:
      PX_ANIMATE(.clk(clk_100MHz),  // clk
                 .rst(rst_s),       // rst
                 .video(video),     // video
                 .sw(sw),           // sw 
                 .pixel_x(pixel_x), // pixel_x
                 .pixel_y(pixel_y), // pixel_y
                 .rgb(rgb_next));   // rgb
       
   // RGB Buffer
   always@(posedge clk_100MHz)
      if (rst_s)
         rgb_reg <= 12'b0; 
      else if (pixel_tick)
         rgb_reg <= rgb_next;
		
   // RGB Output
   assign rgb = rgb_reg;

endmodule
          