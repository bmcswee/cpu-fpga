module mojo_top(
    // 50MHz clock input
    input clk,
	 input rst,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // Brendan stuff
    input [7:0] trainer_dip, // opcode input
	 // debug outputs
	 output [7:0] r0view,
	 output [7:0] r1view,
	 output [7:0] r2view,
	 output [7:0] r3view
    );


// ABOVE: Boilerplate
// BELOW: My code

// create registers
reg [7:0] r0; // program counter
reg [7:0] r1;
reg [7:0] r2;
reg [7:0] r3;

// DEBUG purposes only
assign r3view = r3;
assign r2view = r2;
assign r1view = r1;
assign r0view = r0;

// wire the LEDs to r3 for output display purposes
assign led = r3;

// other vars
wire activate_cpu;

// assign initial values to registers
initial r0 = 8'b00000000;
initial r1 = 8'b00000000;
initial r2 = 8'b00000000;
initial r3 = 8'b00000000;

// convenience variables
wire [3:0] opcode;
assign opcode = trainer_dip[7:4];
wire [1:0] dst;
assign dst = trainer_dip[3:2];
wire [1:0] src;
assign src = trainer_dip[1:0];

// cpu internal caches
reg [7:0] destvalue = 8'b00000000;
reg [7:0] srcvalue = 8'b00000000;
reg [7:0] cpuinternal = 8'b00000000;

button cycle_cpu (
      .clk(clk),
      .rst(rst),
      .out(activate_cpu)
    );

always @(posedge clk) begin
  if (activate_cpu) begin
    case (dst)
      2'b01    : destvalue = r1;
      2'b10    : destvalue = r2;
      2'b11    : destvalue = r3;
    endcase
    
    case (src)
      2'b01    : srcvalue = r1;
      2'b10    : srcvalue = r2;
      2'b11    : srcvalue = r3;
    endcase
    
    case (opcode)
      4'b0000  : cpuinternal = destvalue; // NOP
      4'b0001  : cpuinternal = srcvalue + destvalue; // ADD
      4'b0010  : cpuinternal = destvalue - srcvalue; // SUB
		  4'b0011	: cpuinternal = ~destvalue; // NOT
		  4'b0100	: cpuinternal = srcvalue & destvalue; // AND
		  4'b0101	: cpuinternal = srcvalue | destvalue; // OR
		  4'b0110	: cpuinternal = srcvalue ^ destvalue; // XOR
		  4'b0111	: cpuinternal = destvalue + 1; // INC
		  4'b1000	: cpuinternal = src; // MOV, !!!!IMPORTANT: src must be a value, not a register
    endcase
    
    // now assign the new value to its proper place
    case (dst)
      2'b01    : r1 = cpuinternal;
      2'b10    : r2 = cpuinternal;
      2'b11    : r3 = cpuinternal;
    endcase
	 
	 // increment program counter
	 r0 = r0 + 1;
  end
end

endmodule