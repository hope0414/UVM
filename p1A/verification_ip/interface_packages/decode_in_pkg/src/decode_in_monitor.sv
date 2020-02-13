class decode_in_monitor extends uvm_monitor;

  protected time time_stamp = 0;
  decode_in_transaction trans;
  int transaction_viewing_stream;
  bit enable_transaction_viewing;
  virtual decode_in_monitor_bfm bfm;

  `uvm_component_utils(decode_in_monitor)
  uvm_analysis_port #(decode_in_transaction) monitored_ap;


  function new(string name ="", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_bfm_proxy_handle();
    monitored_ap = new("monitored_ap", this);

	`uvm_info("INFO","Message from decode_in_monitor build_phase", UVM_LOW);
  endfunction

  virtual function void set_bfm_proxy_handle();
    bfm.proxy = this;
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ->bfm.go;
	phase.drop_objection(this);
	`uvm_info("INFO","Message from decode_in_monitor run_phase", UVM_LOW);
  endtask

  virtual function void notify_transaction(
        input logic [15:0] dout,
        input logic [15:0] npc_in
      );
      trans = new("trans");
      trans.start_time = time_stamp;
      trans.end_time = $time;
      time_stamp = trans.end_time;
      trans.Instr_dout = dout;
      trans.npc_in = npc_in;
      analyze(trans);

  endfunction



  virtual function void analyze(decode_in_transaction trans);
      if(enable_transaction_viewing)
        trans.add_to_wave(transaction_viewing_stream);

      monitored_ap.write(trans);
  endfunction
  
  virtual function void start_of_simulation_phase(uvm_phase phase);
    if(enable_transaction_viewing)
    transaction_viewing_stream=$create_transaction_stream({"..", get_full_name(),".","txn_stream"});

    `uvm_info("INFO","Message from decode_in_monitor start_of_simulation_phase", UVM_LOW);
  endfunction
endclass
