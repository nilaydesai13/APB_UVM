// Driver gets the sequence from the sequencer and drives it to the DUT via interface

class apb_master_driver extends uvm_driver#(apb_master_trans);
  `uvm_component_utils(apb_master_driver)
  
  virtual apb_if vif;
  
  function new(string name = "apb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_if)::get(this, "", "apb_if", vif))
       `uvm_fatal("apb_master_driver", "COULD NOT GET INTERFACE");
  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    this.vif.apb_cb.psel    <= 0;
    this.vif.apb_cb.penable <= 0;

    forever begin
      apb_master_trans tr;
      @ (this.vif.apb_cb);
      
      //First get an item from sequencer
      seq_item_port.get_next_item(tr);
      @ (this.vif.apb_cb);
      uvm_report_info("APB_DRIVER ", $psprintf("Got Transaction %s",tr.convert2string()));
      
      //Decode the sequence type and call either the read/write task
      case (tr.pwrite)
        apb_master_trans::READ:  read_trans(tr.paddr, tr.pdata);  
        apb_master_trans::WRITE: write_trans(tr.paddr, tr.pdata);
      endcase
     
      seq_item_port.item_done();
    end
  endtask: run_phase
    
  virtual task read_trans(input  bit   [31:0] paddr, output logic [31:0] pdata);
    // first drive paddr, pwrite and psel
    this.vif.apb_cb.paddr   <= paddr;
    this.vif.apb_cb.pwrite  <= 0;
    this.vif.apb_cb.psel    <= 1;
    
    // one clock later drive penable
    @ (this.vif.apb_cb);
    this.vif.apb_cb.penable <= 1;
    
    @ (this.vif.apb_cb);
    pdata = this.vif.apb_cb.prdata;
    
    // reset penable and psel for next transaction
    this.vif.apb_cb.psel    <= 0;
    this.vif.apb_cb.penable <= 0;
  endtask

  virtual task write_trans(input bit [31:0] paddr, input bit [31:0] pdata);
    // first drive paddr, pwrite and psel
    this.vif.apb_cb.paddr   <= paddr;
    this.vif.apb_cb.pwdata  <= pdata;
    this.vif.apb_cb.pwrite  <= 1;
    this.vif.apb_cb.psel    <= 1;
    
    // one clock later drive penable
    @ (this.vif.apb_cb);
    this.vif.apb_cb.penable <= 1;
    @ (this.vif.apb_cb);
    
    // reset penable and psel for next transaction
    this.vif.apb_cb.psel    <= 0;
    this.vif.apb_cb.penable <= 0;
  endtask
endclass: apb_master_driver