`timescale 1ns / 1ps
/****************************** C E C S  3 6 0 ******************************
 * 
 * File Name:  pixel_generator.v
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
module vga_animate(clk, rst, video, sw, pixel_x, pixel_y, rgb);
	input        clk, rst, video;
   input  [1:0] sw;
	input  [9:0] pixel_x, pixel_y;
	output [11:0] rgb;
   wire   [9:0] pixel_x, pixel_y;
   reg    [11:0] rgb;
	// Display Objects
	wire         ball, paddle, wall;
	wire   [11:0] c_ball, c_paddle, c_wall;
   
   // 60Hz enable tick - Asserted once clock period per 60Hz cycle
   wire refr_tick;
   assign refr_tick = (pixel_y == 481) && (pixel_x == 0);
	
	// Ball Pixel Setup
   // Boundaries
   wire   [9:0] ball_left, ball_right, ball_top, ball_bottom, ball_default;
   assign ball_left = ball_x_reg;
   assign ball_top = ball_y_reg;
   assign ball_right = ball_left + 3'b111;
   assign ball_bottom = ball_top + 3'b111;
   // Position 
   reg    [9:0] ball_x_reg, ball_y_reg;
   wire         gameover;
   assign gameover = (ball_right >= 639);
   wire   [9:0] ball_x_next, ball_y_next;
	assign ball = (pixel_x >= ball_left) && (pixel_x <= ball_right) &&
					  (pixel_y >= ball_top) && (pixel_y <= ball_bottom);
   assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg : ball_x_reg;
   assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg : ball_y_reg;
   always @ (*)
   begin
      x_delta_next = x_delta_reg;
      y_delta_next = y_delta_reg;
      // Ball hits top
      if(ball_top < 1)
         y_delta_next = 2;
      // Ball hits bottom
      else if(ball_bottom > (480 - 1))
         y_delta_next = -2;
      // Ball hits wall
      else if((32 <= ball_right) && (ball_right <= 35) &&
              (wall_top <= ball_bottom) && (ball_top <= wall_bottom))
         x_delta_next = 2;
      // Ball hits paddle
      else if((600 <= ball_right) && (ball_right <= 603) &&
              (paddle_top <= ball_bottom) && (ball_top <= paddle_bottom))
         x_delta_next = -2;

   end
   // Speed
   reg    [9:0] x_delta_reg, x_delta_next;
   reg    [9:0] y_delta_reg, y_delta_next;
   // Color - Black
   assign c_ball = 12'b1000_1000_1000;
   
	// Paddle Pixel Setup
   // Boundaries
   wire   [9:0] paddle_top, paddle_bottom;
   assign paddle_top = paddle_reg;
   assign paddle_bottom = paddle_top + 7'b1000111;
   // Position
   reg    [9:0] paddle_reg, paddle_next;   
	assign paddle = (pixel_x >= 600) && (pixel_x <= 603) &&
						 (pixel_y >= paddle_top) && (pixel_y <= paddle_bottom);
   always @ (*)
   begin
      // No Movement
      paddle_next = paddle_reg;
      if(refr_tick)
         // Downward Movement
         if(sw[1] & (paddle_bottom < 475))
            paddle_next = paddle_reg + 3'b100;
         // Upward Movement   
         else if(sw[0] & (paddle_top > 3'b100))
            paddle_next = paddle_reg - 3'b100;
   end
   // Color - Blue Green
	assign c_paddle = 12'b0000_1001_0011; 
							
	// Wall Pixel Setup
   //Boundaries
   wire   [9:0] wall_top, wall_bottom;
   assign wall_top = wall_reg;
   assign wall_bottom = wall_top + 7'b1000111;
   //Position
   reg   [9:0] wall_reg, wall_next;
	assign wall = (pixel_x >= 32) && (pixel_x <= 35) &&
                 (pixel_y >= wall_top) && (pixel_y <= wall_bottom);
   always @ (*)
   begin
      wall_next = wall_reg;
      if(refr_tick)
         // Downward Movement
         if((ball_bottom >= wall_bottom) &  (wall_bottom < 475))
            wall_next = wall_reg + 3'b100;
         // Upward Movement   
         else if((ball_top <= wall_top) & (wall_top > 3'b100))
            wall_next = wall_reg - 3'b100;
   end
   // Color - Red
	assign c_wall   = 12'b1111_1000_1100;   
	 
   // Registers
   always @ (posedge clk or posedge rst)
      if(rst)
         begin
            paddle_reg <= 0;
            wall_reg <= 0;
            ball_x_reg <= 36;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
         end
      else if(gameover)
         begin
            paddle_reg <= paddle_next;
            wall_reg <= wall_next;
            ball_x_reg <= 36;
            ball_y_reg <= 0;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
         end      
      else
         begin
            paddle_reg <= paddle_next;
            wall_reg <= wall_next;
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
         end
   
	// RGB Setup - Fills color
	always @ (*)
      if (~video)
         rgb = 12'b0000_0000_0000; // Black
      else
         if (ball)
            rgb = c_ball;
         else if (paddle)
            rgb = c_paddle;
         else if (wall)
            rgb = c_wall;
         else
            rgb = 12'b1111_0111_0111; // Gray

endmodule
