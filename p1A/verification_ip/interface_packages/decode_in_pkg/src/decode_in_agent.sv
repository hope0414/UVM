class decode_in_agent extends uvm_agent;
  decode_in_sequencer sqr;
  decode_in_driver driver;
  decode_in_monitor mon;
  decode_in_coverage cov;
  decode_in_configuration cfg;

  bit en_cov;
  bit is_active;

  `uvm_component_utils(decode_in_agent)
  uvm_analysis_port #(decode_in_transaction) agent_ap;

  function new(string name = "decode_in_agent", uvm_component parent=null);
    super.new(name,parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(decode_in_configuration)::get(this,"","cfg",cfg))
      `uvm_fatal("decode_in_agent","config_db_failed");


    is_active = cfg.is_active;
    en_cov = cfg.en_cov;
    mon = decode_in_monitor::type_id::create("mon",this);
    mon.bfm=cfg.mon_bfm;
    mon.enable_transaction_viewing = cfg.enable_transaction_viewing;

    if(is_active) begin
      sqr=decode_in_sequencer::type_id::create("sqr",this);
      driver = decode_in_driver::type_id::create("driver",this);
      driver.bfm=cfg.drv_bfm;
    end

    if(en_cov)
      cov=decode_in_coverage::type_id::create("cov",this);


	`uvm_info("INFO","Message from decode_in_agent build_phase", UVM_LOW);


  endfunction

    virtual function void connect_phase(uvm_phase phase);
      agent_ap = mon.monitored_ap;
      if(is_active)
        driver.seq_item_port.connect(sqr.seq_item_export);
      if(en_cov)
        mon.monitored_ap.connect(cov.analysis_export);


	`uvm_info("INFO","Message from decode_in_agent connect_phase", UVM_LOW);
    endfunction
endclass
