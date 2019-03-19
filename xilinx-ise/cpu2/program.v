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
    program[0] = 8'b10001111; // MOV R3 <- 3
    program[1] = 8'b10001011; // MOV R2 <- 3
    program[2] = 8'b10000101; // MOV R1 <- 1
	 program[3] = 8'b10011011; // CMP R2, R3
	 program[4] = 8'b10011101; // CMP R3, R1
	 program[5] = 8'b10010111; // CMP R1, R3
  end

  /* Combinational Logic */
  always @* begin
    outputline = program[linenumber];
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
    end else begin
      // Add flip-flop q <= d statements here
    end
  end
  
endmodule
