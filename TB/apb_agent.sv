class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  apb_master_driver drv;
  apb_sequencer sqr;
  apb_monitor mon;
  
  virtual apb_if vif;
  
  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  virtual function void build_phase(uvm_phase phase);  
    drv = apb_master_driver::type_id::create("drv", this);
    sqr = apb_sequencer::type_id::create("sqr", this);
    mon = apb_monitor::type_id::create("mon", this);
    
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", vif)) begin
      `uvm_fatal("APB_AGENT", "COULD NOT GET VIRTUAL INTERFACE")
      end
    
    uvm_config_db#(virtual apb_if)::set( this, "*", "apb_if", vif);

  endfunction: build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction: connect_phase
endclass: apb_agent