module blinker (
    input clk,  // clock
    input rst,  // reset
    output blink
  );
  
  reg [24:0] counter_d, counter_q;
  
  assign blink = counter_q[24];

  /* Combinational Logic */
  always @(counter_q) begin
    counter_d = counter_q + 1'b1;
  end
  
  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      // Add flip-flop reset values here
      counter_q <= 25'b0;
    end else begin
      // Add flip-flop q <= d statements here
      counter_q <= counter_d;
    end
  end
  
endmodule
