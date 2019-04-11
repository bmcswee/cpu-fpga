module mojo_top(
// 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
	 // debug outputs
	 //output [7:0] r0view,
	 output [7:0] r1view,
	 output [7:0] r2view,
	 output [7:0] r3view,
	 output zfview,
	 output cfview
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

// ABOVE: Boilerplate
// BELOW: My code

// create registers
reg [7:0] r0; // program counter
reg [7:0] r1;
reg [7:0] r2;
reg [7:0] r3;
reg zf; // Zero flag
reg cf; // Carry flag

// DEBUG purposes only
assign r3view = r3;
assign r2view = r2;
assign r1view = r1;
//assign r0view = r0;
//assign zfview = zf;
//assign cfview = cf;

// wire the LEDs to r0 for output display purposes
assign led = r0;

// other vars
wire activate_cpu;

// assign initial values to registers
initial r0 = 8'b00000000;
initial r1 = 8'b00000000;
initial r2 = 8'b00000000;
initial r3 = 8'b00000000;
initial zf = 1'b0;
initial cf = 1'b0;

// convenience variables
reg [3:0] opcode;
//assign opcode = trainer_dip[7:4];
reg [1:0] dst;
//assign dst = trainer_dip[3:2];
reg [1:0] src;
//assign src = trainer_dip[1:0];

// cpu internal caches
reg [7:0] destvalue = 8'b00000000;
reg [7:0] srcvalue = 8'b00000000;
reg [7:0] cpuinternal = 8'b00000000;
reg update_dst = 1'b0;
reg increment_pc = 1'b0;

// instruction retrieved from "program"
wire [7:0] program_instruction;

button cycle_cpu (
      .clk(clk),
      .rst(rst),
      .out(activate_cpu)
    );

program test_program (
      .clk(clk),
      .rst(rst),
      .linenumber(r0),
      .out(program_instruction)
    );

always @(posedge clk) begin
  if (activate_cpu) begin
    // break up program instruction into component pieces
    opcode = program_instruction[7:4];
    dst = program_instruction[3:2];
    src = program_instruction[1:0];
	 
	 update_dst = 1'b1; // by default, assume we need to update the destination
	 increment_pc = 1'b1; // by default, increment the program counter
  
    // process the instruction
    
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
		  4'b1001	: // CMP
			begin
				update_dst = 1'b0;
				if (destvalue < srcvalue) begin
					zf = 1'b0;
					cf = 1'b1;
				end else if (destvalue > srcvalue) begin
					zf = 1'b0;
					cf = 1'b0;
				end else begin
					zf = 1'b1;
					cf = 1'b0;
				end
			end
		  4'b1010	: // JZ
			begin
				if (zf  == 1'b1) begin
					r0 = program_instruction[3:0]; // set PC to low 4 bits of instruction
					increment_pc = 1'b0;
          update_dst = 1'b0;
				end
			end
		  4'b1011	: // JNZ
			begin
				if (zf  != 1'b1) begin
					r0 = program_instruction[3:0]; // set PC to low 4 bits of instruction
					increment_pc = 1'b0;
          update_dst = 1'b0;
				end
			end
      4'b1100 : // JMP
      begin
        r0 = program_instruction[3:0];
        increment_pc = 1'b0;
        update_dst = 1'b0;
      end
    endcase
    
    // now assign the new value to its proper place
	 if (update_dst == 1) begin
		 case (dst)
			2'b01    : r1 = cpuinternal;
			2'b10    : r2 = cpuinternal;
			2'b11    : r3 = cpuinternal;
		 endcase
	 end
	 
	 // increment program counter
	 if (increment_pc == 1) begin
		r0 = r0 + 1;
	 end
  end
end

endmodule