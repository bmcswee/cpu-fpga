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

// MAKE SURE TO REMOVE ALL OTHER INPUTS FROM MAIN MODULE BEFORE RUNNING THIS TEST IN XILINX

module mojo_top_tb;

	// Inputs
	reg [7:0] trainer_dip;

	// Outputs
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	mojo_top uut (
    .trainer_dip(trainer_dip),
    .led(led)
	);

	initial begin
		// Initialize Inputs
		trainer_dip = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#50 trainer_dip = 8'b00000001;
		#50 trainer_dip = 8'b00001111;
		#50 trainer_dip = 8'b10001111;
		#50 $stop;
	end
      
endmodule

