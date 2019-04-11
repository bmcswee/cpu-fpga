module program (
    input clk,
    input rst,
    input [7:0] linenumber,
    output [7:0] out
  );
  
  reg [7:0] outputline;
  reg [16:0] program [64:0];
  assign out = outputline;
  
  initial begin
    program[0] = 8'b00000000; // NOP
    program[1] = 8'b10001011; // MOV R2 <- 3
    program[2] = 8'b10000110; // MOV R1 <- 2
    program[3] = 8'b00011001; // ADD R2, R1
    program[4] = 8'b00110100; // NOT R1
    program[6] = 8'b10001101;
    program[7] = 8'b00111100;
    program[8] = 8'b11000001; // JMP instruction 1
    
  // OLD PROGRAM
    //program[0] = 8'b10001111; // MOV R3 <- 3
    //program[1] = 8'b10001011; // MOV R2 <- 3
    //program[2] = 8'b10000101; // MOV R1 <- 1

	 //program[3] = 8'b00011110; // ADD R3, R2
	 
	 // Essentially: While (R1 != R3)
	 //program[4] = 8'b01110100; // INC R1
	 //program[5] = 8'b10010111; // CMP R1, R3
	 //program[6] = 8'b10110100; // JNZ instruction 4
	 // End while
	 
	 //program[7] = 8'b00011101; // ADD R3, R1
   outputline = program[0];
  end

  /* Combinational Logic */
  always @* begin
    outputline = program[linenumber];
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    //outputline = program[linenumber];
  end
  
endmodule
