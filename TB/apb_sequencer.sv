// Sequencer connects the driver and the sequence

class apb_sequencer extends uvm_sequencer#(apb_master_trans);
  `uvm_component_utils(apb_sequencer)
  
  function new(string name = "apb_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction
endclass: apb_sequencer