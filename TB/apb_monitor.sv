// Monitor monitors the interface, samples activity and converts signal to transaction to send it to scoreboard

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_if vif;
  
  uvm_analysis_port#(apb_master_trans) ap;  // Analysis port
  
  function new(string name = "apb_monitor", uvm_component parent);
    super.new(name,parent);
    ap = new("ap", this);
  endfunction: new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_if)::get(this, "", "apb_if", vif))
      `uvm_fatal("apb_monitor", "COULD NOT GET INTERFACE");
  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
     forever begin
       apb_master_trans tr;
       
       // Wait for SETUP
       do begin
         @ (this.vif.mon_cb);
         end
       while (this.vif.mon_cb.psel !== 1'b1 ||
              this.vif.mon_cb.penable !== 1'b0);
       
       //create a transaction object
       tr = apb_master_trans::type_id::create("tr", this);
        
       //Check the type of transaction and sample address
       if(this.vif.mon_cb.pwrite) begin
         tr.pwrite = apb_master_trans::WRITE;
       end else begin
         tr.pwrite = apb_master_trans::READ;
       end
       tr.paddr = this.vif.mon_cb.paddr;
	   
       // Check penable on the next clk - protocol checking
       @(this.vif.mon_cb);
       if (this.vif.mon_cb.penable !== 1'b1) begin
         `uvm_error("APB_MONITOR", "SETUP cycle not followed by ENABLE cycle");
       end
       
       // add to "tr" depending upon read or write
       if (tr.pwrite == apb_master_trans::READ) begin
         tr.pdata = this.vif.mon_cb.prdata;
       end
       else if (tr.pwrite == apb_master_trans::WRITE) begin
         tr.pdata = this.vif.mon_cb.pwdata;
       end
      
       `uvm_info("APB_MONITOR", $sformatf("Got Transaction %s",tr.convert2string()), UVM_NONE);
       
       //Write to analysis port
       ap.write(tr);
     end
  endtask
endclass: apb_monitor