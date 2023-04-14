// APB Interface with a driver and a monitor clocking block

interface apb_if(input bit clk);
    bit        rst_n;
  logic  [7:0] paddr;
  logic 	   pwrite;
  logic 	   psel;
  logic 	   penable;
  logic  [31:0] pwdata;
  logic  [31:0] prdata;
  
  clocking apb_cb @(posedge clk); // used to drive
  	default input #1ns output #2ns;
    output paddr, pwrite, psel, penable, pwdata, rst_n;
    input prdata;
  endclocking: apb_cb
  
  clocking mon_cb @(posedge clk); // used to sample interface for scoreboard
     input paddr, psel, penable, pwrite, prdata, pwdata;
  endclocking: mon_cb
endinterface