module button (
    input clk,  // clock
    input rst,  // reset
    output[7:0] out
  );
  
  reg [7:0] counter = 8'b0;
  assign out = counter;
  
  reg oldRst, rstPressed;

  /* Combinational Logic */
  always @* begin
    if (rst) begin
      //counter[0] = ~counter[0];
    end
    
    if (rst&&!oldRst) begin
      rstPressed = 1;
    end else begin
      rstPressed = 0;
    end
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    oldRst<=rst;
    if (rstPressed) begin
      // Add flip-flop reset values here
      counter = counter + 1;
    end else begin
      // Add flip-flop q <= d statements here
    end
  end
  
endmodule
