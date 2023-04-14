class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agent;
  apb_scoreboard sb;
  
  virtual apb_if vif;
  
  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = apb_agent::type_id::create("agent", this);
    sb = apb_scoreboard::type_id::create("sb", this);
    
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", vif))
      `uvm_fatal("APB_ENV", "COULD NOT GET VIRTUAL INTERFACE");
    
    uvm_config_db#(virtual apb_if)::set( this, "*", "apb_if", vif);
   endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     agent.mon.ap.connect(sb.a_exp);
   endfunction
  
endclass: apb_env