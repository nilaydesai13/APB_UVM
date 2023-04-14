// Create, start, randomize and finish the sequence

class apb_seq extends uvm_sequence#(apb_master_trans);
  `uvm_object_utils(apb_seq)
  
  function new(string name = "apb_seq");
    super.new(name);
  endfunction: new
  
  virtual task body();
    apb_master_trans tr;
    repeat (100) begin
      tr = new();
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
  endtask: body
endclass: apb_seq