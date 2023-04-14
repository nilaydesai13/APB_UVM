class apb_master_trans extends uvm_sequence_item;
  
  `uvm_object_utils(apb_master_trans)
  
  typedef enum {READ, WRITE} rw_e;
  rand logic [31:0] paddr;
  rand logic [31:0] pdata;
  rand rw_e  pwrite;
  
  constraint size { paddr inside {[125:135]};};
  
  function new(string name = "apb_master_trans");
    super.new(name);
  endfunction: new
  
  function string convert2string();
    return $psprintf("pwrite=%s paddr=%0h pdata=%0h",pwrite, paddr, pdata);
  endfunction
endclass: apb_master_trans