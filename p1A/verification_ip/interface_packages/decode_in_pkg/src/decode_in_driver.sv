class decode_in_driver extends uvm_driver #(decode_in_transaction);
  virtual decode_in_driver_bfm bfm;
  `uvm_component_utils(decode_in_driver)

  function new(string name="decode_in_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("INFO", "Message from decode_in_driver build_phase", UVM_LOW);
  endfunction

  virtual task run_phase(uvm_phase phase);

    super.run_phase(phase);

    forever begin
      seq_item_port.get_next_item(req);
      access(req);
      seq_item_port.item_done();

    end

	  `uvm_info("INFO","Message from decode_in_driver run_phase", UVM_LOW);
  endtask

  virtual task access(inout decode_in_transaction txn);

    bfm.access(txn.Instr_dout, txn.npc_in);

  endtask

endclass
