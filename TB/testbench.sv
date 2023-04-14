// Purpose of this TB is to get familiar with UVM methodology.
// The emphasis is on building various components of UVM.
// This testbench acts as a APB bridge/Master and communicates with the DUT (APB slave). It either writes to the DUT or requests data from it.

`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "apb_if.sv"

//import uvm_pkg::*;
import apb_pkg::*;

module tb;
  bit clk;
  
  apb_if intf(clk);
  
  apb_slave DUT(
    .clk     (clk),
    .rst_n   (intf.rst_n),
    .paddr   (intf.paddr),
    .pwrite  (intf.pwrite),
    .psel    (intf.psel),
    .penable (intf.penable),
    .pwdata	 (intf.pwdata),
    .prdata  (intf.prdata)
  );
  
  initial clk = 1'b0;
  
  always #10 clk = ~clk;
  
  initial begin
    uvm_config_db #(virtual apb_if)::set(null,"*","apb_if",intf);
  end
  
  initial begin
    run_test("apb_test");
  end
  


endmodules