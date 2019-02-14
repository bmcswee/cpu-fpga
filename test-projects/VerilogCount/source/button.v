module button (
    input clk,  // clock
    input rst,  // reset
    output[7:0] out
  );
  
  reg [7:0] counter = 8'b0;
  assign out = counter[0];

  /* Combinational Logic */
  always @* begin
    if (rst) begin
      counter = 1;
    end
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
