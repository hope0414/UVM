class decode_in_coverage extends uvm_subscriber #(decode_in_transaction);
    
  opcode_t opcode;
  logic [15:0] npc_in;

  `uvm_component_utils(decode_in_coverage);
  
  covergroup decode_in_transaction_cg;
    option.per_instance = 1;
    option.name = get_full_name();

    coverpoint npc_in;

  opcode_type: coverpoint opcode
  {
    bins ADD = {ADD};
    bins AND = {AND};
    bins NOT = {NOT};
    bins LD = {LD};
    bins LDR = {LDR};
    bins LDI = {LDI};
    bins LEA = {LEA};
    bins ST = {ST};
    bins STR = {STR};
    bins STI = {STI};
    bins BR = {BR};
    bins JMP = {JMP};
  }




  endgroup

  function new(string name="decode_in_coverage", uvm_component parent = null);
    super.new(name, parent);
    decode_in_transaction_cg = new;
  endfunction

  virtual function void write(decode_in_transaction t);
    opcode = opcode_t'(t.Instr_dout[15:12]);
    npc_in = t.npc_in;

    decode_in_transaction_cg.sample();

  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("INFO", "Message from decode_in_coverage build_phase", UVM_LOW);
  endfunction


endclass
