`timescale 1ns / 1ps
/****************************** C E C S  3 6 0 ******************************
 * 
 * File Name:  vga.v
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
module vga(clk_100MHz, rst, hsync, vsync, video, pixel_tick, pixel_x, pixel_y);
    input        clk_100MHz, rst;
   output        hsync, vsync, video, pixel_tick;
   output  [9:0] pixel_x, pixel_y;
     wire        clk_100MHz, rst, hsync, vsync, video, pixel_tick;
     wire  [9:0] pixel_x, pixel_y;
     
   // Constant Declaration
   // VGA 640-by-480 sync parameters
   localparam HD = 640, // Horizontal display area
              HF = 48,  // Horizontal left
              HB = 16,  // Horizontal right
              HR = 96,  // Horizontal retrace
              VD = 480, // Vertical display area
              VF = 10,  // Vertical top
              VB = 33,  // Vertical bottom
              VR = 2;   // Vertical retrace
              
   // Sync counters
   reg [9:0] h_count_reg, h_count_next;
   reg [9:0] v_count_reg, v_count_next;
   // Output buffer
   reg       v_sync_reg, h_sync_reg;
   reg       v_sync_next, h_sync_next;
   // Status signal
   wire      h_end, v_end, tick;
   
   // Body
   // Registers
   always @ (posedge clk_100MHz or posedge rst)
      if (rst) 
         begin
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg <= 1'b0;
            h_sync_reg <= 1'b0;
         end
      else 
         begin
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= ~v_sync_next;
            h_sync_reg <= ~h_sync_next;
         end
         
   // Circuit to generate 25 MHz enable tick
   reg    [1:0] count, n_count;
   // Behavioral section for writing to registers   
   always @ (posedge clk_100MHz or posedge rst)
      if (rst) count <= 2'b0;
         else count <= n_count;
   // Wire output 
   assign tick = (count == 3);
   // Comparator
   always @ (*)
      n_count = (tick) ? 2'b0 : count + 2'b1;
      
   // Status signals
   // End of horizontal counter (799)
   assign h_end = (h_count_reg == (HD + HF + HB + HR - 1));
   // End of vertical counter (524)
   assign v_end = (v_count_reg == (VD + VF + VB + VR - 1));
   
   // Next-state logic of mod-800 horizontal sync counter
   always @ (*)
      if (tick)
         if (h_end)
            h_count_next = 0;
         else
            h_count_next = h_count_reg + 10'b1;
      else
         h_count_next = h_count_reg;   
 
   // Next-state logic of mod-525 vertical sync counter 
   always @ (*)
      if (tick & h_end)
         if (v_end)
            v_count_next = 0;
         else
            v_count_next = v_count_reg + 10'b1;
      else
         v_count_next = v_count_reg;
         
   // Horizontal and vertical sync, buffered to avoid glitch
   // h_sync_next asserted between 656 and 751
   always @ (*)
      h_sync_next = (h_count_reg >= (HD + HB) && 
                     h_count_reg <= (HD + HB + HR - 1));
   // h_sync_next asserted between 490 and 491
   always @ (*)
      v_sync_next = (v_count_reg >= (VD + VF) && 
                     v_count_reg <= (VD + VF + VR - 1));    
      
   // Video on/off
   assign video = (h_count_reg < HD) && (v_count_reg < VD);
   
   // Output
   assign hsync = h_sync_reg;
   assign vsync = v_sync_reg;
   assign pixel_x = h_count_reg;
   assign pixel_y = v_count_reg;
   assign pixel_tick = tick;

endmodule
