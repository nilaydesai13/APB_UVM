// Scoreboard gets transaction sampled by monitor and checks if the data matches
// Comparing data read from the DUT against expected data.

class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp#(apb_master_trans, apb_scoreboard) a_exp;
  
  apb_master_trans queue_sb[$]; // Queues are used to push back the transactions from monitor 
  
  bit [31:0] store_sb [0:256];  // mimicking he memory inside the DUT
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    a_exp = new("a_exp", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(store_sb[i]) store_sb[i] = i;  // Feeling up the sb mem just as in the DUT
  endfunction
  
  // write task - recives the pkt from monitor and pushes into queue
  function void write(apb_master_trans tr);
    queue_sb.push_back(tr);
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    apb_master_trans expected_data;
    
    forever begin
      // wait till we get something
      wait(queue_sb.size() > 0);
      
      // pop from queue
      expected_data = queue_sb.pop_front();
      
      // check if it's a read/write transaction and act accordingly
      if(expected_data.pwrite == apb_master_trans::WRITE) begin
        
        // Keep the scoreboard mem up-to-date with new data if it's a write transaction
        store_sb[expected_data.paddr] = expected_data.pdata;
        
        `uvm_info("APB_SCOREBOARD",$sformatf("------ THIS IS A WRITE TRANSACTION ------"),UVM_LOW)
        `uvm_info("APB_SCOREBORD",$sformatf("Addr: %0h",expected_data.paddr),UVM_LOW)
        `uvm_info("APB_SCOREBORD",$sformatf("Data: %0h",expected_data.pdata),UVM_LOW)
        `uvm_info("APB_SCOREBORD", $sformatf("\n----------------------------------------------------"), UVM_NONE)
      end 
      else if(expected_data.pwrite == apb_master_trans::READ) begin
        `uvm_info("APB_SCOREBOARD",$sformatf("------ THIS IS A READ TRANSACTION ------"),UVM_LOW)
        
        // Check the read data against what exists in the scoreboard mem
        if(store_sb[expected_data.paddr] == expected_data.pdata) begin
          `uvm_info("APB_SCOREBOARD",$sformatf("------ READ DATA Match ------"),UVM_LOW)
          `uvm_info("APB_SCOREBORD",$sformatf("Addr: %0h",expected_data.paddr),UVM_LOW)
          `uvm_info("APB_SCOREBORD",$sformatf("Expected Data: %0h Actual Data: %0h",store_sb[expected_data.paddr],expected_data.pdata),UVM_LOW)
          `uvm_info("APB_SCOREBORD", $sformatf("\n----------------------------------------------------"), UVM_NONE)
        end
        else begin
          `uvm_error("APB_SCOREBOARD","------ :: READ DATA MisMatch :: ------")
          `uvm_info("APB_SCOREBOARD",$sformatf("Addr: %0h",expected_data.paddr),UVM_LOW)
          `uvm_info("APB_SCOREBOARD",$sformatf("Expected Data: %0h Actual Data: %0h",store_sb[expected_data.paddr],expected_data.pdata),UVM_LOW)
        end
      end
    end
  endtask 
  
endclass