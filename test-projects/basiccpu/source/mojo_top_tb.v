`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:30:10 03/01/2019
// Design Name:   mojo_top
// Module Name:   C:/Users/Brendan/Desktop/school/xilinx/mojo-base-project/mojo_top_tb.v
// Project Name:  Mojo-Base
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mojo_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mojo_top_tb;

	// Inputs
	reg [7:0] trainer_dip;
	reg activate_button;
	reg clk, rst;

	// Outputs
	wire [7:0] led;
	wire [7:0] r0view, r1view, r2view, r3view;

	// Instantiate the Unit Under Test (UUT)
	mojo_top uut (
	 .clk(clk),
	 .rst(activate_button),
    .trainer_dip(trainer_dip),
    .led(led),
	 .r0view(r0view),
	 .r1view(r1view),
	 .r2view(r2view),
	 .r3view(r3view)
	);
	
	initial begin
    clk = 1'b0;
    rst = 1'b1;
    repeat(4) #10 clk = ~clk;
    rst = 1'b0;
    forever #10 clk = ~clk; // generate a clock
	end

	initial begin
		// Initialize Inputs
		trainer_dip = 0;
		activate_button = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#50 trainer_dip = 8'b00011110; // ADD R3 <- R2
		#25 activate_button = 1;
		#25 activate_button = 0;
		#200 $stop;
	end
      
endmodule

