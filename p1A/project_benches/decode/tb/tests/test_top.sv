class test_top extends uvm_test;
    decode_in_agent i_agt;
    decode_in_configuration configuration;


    `uvm_component_utils(test_top)

    function new(string name = "test_top", uvm_component parent = null);
      super.new(name, parent);
 
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      configuration = decode_in_configuration::type_id::create("configuration", this);
      i_agt = decode_in_agent::type_id::create("i_agt", this);
      if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(this, "configuration", "decode_in", configuration.mon_bfm))
      `uvm_fatal("test_top","test_top.configuration didn't get mon_bfm")


      if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(this, "configuration", "decode_in", configuration.drv_bfm))
      `uvm_fatal("test_top","test_top.configuration didn't get drv_bfm")


      if(!uvm_config_db#(bit)::get(this, "configuration", "wave", configuration.enable_transaction_viewing))
      `uvm_fatal("test_top","test_top.configuration didn't get enable_transaction_viewing")


      if(!uvm_config_db#(bit)::get(this, "configuration", "active", configuration.is_active))
      `uvm_fatal("test_top","test_top.configuration didn't get is_active")

      if(!uvm_config_db#(bit)::get(this, "configuration", "coverage", configuration.en_cov))
      `uvm_fatal("test_top","test_top.configuration didn't get en_cov")

       configuration.initialize("CFG", 1, "uvm_test_top.i_agt");

       `uvm_info("INFO","Message from test_top build_phase", UVM_LOW);
    endfunction

    virtual task run_phase(uvm_phase phase);

      //super.run_phase(phase);

    decode_in_random_sequence seq;
      phase.raise_objection(this);

      seq = decode_in_random_sequence::type_id::create("seq",this);


      if(configuration.is_active)
        seq.start(i_agt.sqr);

      phase.drop_objection(this);

      `uvm_info("INFO","Message from test_top run_phase", UVM_LOW);
    endtask


endclass
