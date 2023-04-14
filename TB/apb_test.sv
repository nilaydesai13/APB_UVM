class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env env;
  apb_seq item;
  
  virtual apb_if vif;
  
  function new(string name = "apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_if)::get(this, "", "apb_if", vif))
      `uvm_fatal("APB_TEST", "COULD NOT GET VIRTUAL INTERFACE");
    
    item = apb_seq::type_id::create("item"); 		// create sequence
    env = apb_env::type_id::create("env", this);
    
    uvm_config_db#(virtual apb_if)::set( this, "*", "apb_if", vif);
  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    do_reset();
    item.start(env.agent.sqr);     // start sequence
    #200;
    phase.drop_objection(this);
  endtask: run_phase
  
  task do_reset();
    @(this.vif.apb_cb) vif.rst_n = 1'b0;
    repeat (3) @(this.vif.apb_cb);
    @(this.vif.apb_cb) begin
      vif.rst_n = 1'b1;
      `uvm_info("apb_env", "RESET DONE", UVM_NONE);
    end
  endtask: do_reset
            
endclass: apb_test