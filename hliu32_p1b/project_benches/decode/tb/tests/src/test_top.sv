class test_top extends uvm_test;

    `uvm_component_utils(test_top)

    decode_in_agent i_agt;
    decode_in_configuration configuration;
    decode_in_random_sequence seq;
    uvm_sequencer #(decode_in_transaction) seqr;

    decode_out_agent i_agt_o;
    decode_out_configuration configuration_o;
    decode_out_random_sequence seq_o;

    function new(string name = "test_top", uvm_component parent = null);
      super.new(name, parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      configuration = decode_in_configuration::type_id::create("configuration", this);
      i_agt = decode_in_agent::type_id::create("i_agt", this);
      configuration.initialize(ACTIVE, "uvm_test_top.i_agt", "decode_in");
      configuration.initiator_responder = INITIATOR;
      seq = decode_in_random_sequence::type_id::create("seq",this);

      configuration_o = decode_out_configuration::type_id::create("configuration_o", this);
      i_agt_o = decode_out_agent::type_id::create("i_agt_o", this);
      configuration_o.initialize(PASSIVE, "uvm_test_top.i_agt_o", "decode_out");
      seq_o = decode_out_random_sequence::type_id::create("seq_o",this);

    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
    	super.end_of_elaboration_phase(phase);
    	uvm_top.print_topology();
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      if(!uvm_config_db #(uvm_sequencer #(decode_in_transaction))::get(null, UVMF_SEQUENCERS, "decode_in", seqr))
        `uvm_error("seqr", "didn't get decode_in sequencer");
    endfunction

    virtual task run_phase(uvm_phase phase);

      super.run_phase(phase);

      phase.raise_objection(this);
      repeat(25)
      	seq.start(seqr);
      phase.drop_objection(this);

    endtask


endclass
