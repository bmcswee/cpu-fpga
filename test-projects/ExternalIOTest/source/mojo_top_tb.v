module mojo_top_tb ();

  // designed for http://www.techep.csi.cuny.edu/~zhangs/v.html
  // note that extra module inputs like clock need to be removed for this to work

  reg [7:0] dip_switches;
  wire [7:0] leds;
  
  mojo_top dut (
    .trainer_dip(dip_switches),
    .led(leds)
  );
  
  initial  begin
    $display("\t\t time,\t dip_switches,\t leds"); 
    $monitor("%d, \t%d, \t%d",$time, dip_switches, leds); 
  end 
  
  initial begin
    dip_switches = 8'b00000000;
    #5 dip_switches = 8'b00001111;
    #5 dip_switches = 8'b10001111;
    #10 $stop;
  end
  
endmodule
