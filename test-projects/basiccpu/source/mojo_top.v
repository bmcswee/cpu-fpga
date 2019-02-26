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
    // Brendan stuff
    input [7:0] trainer_dip // opcode input
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
assign opcode = trainer_dip[3:0];
wire [1:0] dst;
assign dst = trainer_dip[5:4];
wire [1:0] src;
assign src = trainer_dip[7:6];

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
    case (src)
      2'b01    : destvalue = r1;
      2'b10    : destvalue = r2;
      2'b11    : destvalue = r3;
    endcase
    
    case (dst)
      2'b01    : srcvalue = r1;
      2'b10    : srcvalue = r2;
      2'b11    : srcvalue = r3;
    endcase
    
    case (opcode)
      4'b0000  : cpuinternal = destvalue; // NOP
      4'b0001  : cpuinternal = srcvalue + destvalue; // ADD
      4'b0010  : cpuinternal = destvalue - srcvalue; // SUB
    endcase
    
    // now assign the new value to its proper place
    case (dst)
      2'b01    : r1 = cpuinternal;
      2'b10    : r2 = cpuinternal;
      2'b11    : r3 = cpuinternal;
    endcase
  end
end

endmodule