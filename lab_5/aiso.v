`timescale 1ns / 1ps
/****************************** C E C S  3 6 0 ******************************
 * 
 * File Name:  aiso.v
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
module aiso(clk, rst, rst_s);
   input  clk, rst;
	output rst_s;
   reg    qMeta, qOk;
   // Behavioral section for writing to registers
   always @ (posedge clk or posedge rst)
      if (rst)	{qMeta, qOk} <= {1'b0, 1'b0};
         else	{qMeta, qOk} <= {1'b1, qMeta};
   // Output goes to an inverter
	assign rst_s = ~qOk;
endmodule

