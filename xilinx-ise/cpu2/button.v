module button (
    input clk,  // clock
    input rst,  // reset
    output out
  );
  
  // This basically just debounces the button.
  reg activate = 1'b0;
  assign out = activate;
  
  reg oldRst, rstPressed;

  /* Combinational Logic */
  always @* begin
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
      activate = 1;
    end else begin
      activate = 0;
    end
  end
  
endmodule
