class decode_in_transaction extends uvm_sequence_item;

  rand opcode_t opcode;
  rand bit [2:0] DR;
  rand bit [2:0] SR1;
  rand bit [2:0] SR2;
  rand bit [2:0] SR;
  rand bit [4:0] imm5;
  rand bit [8:0] PCoffset9;
  rand bit [2:0] BaseR;
  rand bit [5:0] PCoffset6;
  rand NZP_t NZP;
  rand bit ADD_m;
  rand bit AND_m;
  //input
  rand bit [15:0] npc_in;
  //output
  logic [15:0] Instr_dout;
 
  time start_time, end_time;

  `uvm_object_utils_begin(decode_in_transaction)
    `uvm_field_int(Instr_dout, UVM_ALL_ON)
    `uvm_field_int(npc_in, UVM_ALL_ON)
    `uvm_field_int(start_time, UVM_ALL_ON)
  
    `uvm_field_int(end_time, UVM_ALL_ON)
  `uvm_object_utils_end

  //int transaction_view_h = 1'b0;

  function void post_randomize();

    case(opcode)
    ADD: begin
          if(ADD_m) Instr_dout = {ADD, DR, SR1, ADD_m, imm5};
          else Instr_dout = {ADD, DR, SR1, ADD_m, 2'b00, SR2};

        end

    AND: begin
          if(AND_m) Instr_dout = {AND, DR, SR1, AND_m, imm5};
          else Instr_dout = {AND, DR, SR1, AND_m, 2'b00, SR2};

    end

    NOT: begin
        Instr_dout = {NOT, DR, SR1, 6'b111111};
    end

    LD: begin
        Instr_dout = {LD, DR, PCoffset9};
    end

    LDR: begin
        Instr_dout = {LDR, DR, BaseR, PCoffset6};
    end

    LDI: begin
        Instr_dout = {LDI, DR, PCoffset9};
    end

    LEA: begin
        Instr_dout = {LEA, DR, PCoffset9};
    end

    ST: begin
        Instr_dout = {ST, SR, PCoffset9};
    end

    STR: begin
        Instr_dout = {STR, SR, BaseR, PCoffset6};
    end

    STI: begin
        Instr_dout = {STI, SR, PCoffset9};
    end

    BR: begin
        Instr_dout = {BR, NZP, PCoffset9};
    end

    JMP: begin
        Instr_dout = {JMP, 3'b000, BaseR, 6'b000000};
    end


    endcase

  endfunction


  function new(string name="decode_in_transaction");
    super.new(name);

  endfunction

  virtual function string convert2string();
    return {super.convert2string(),
    $sformatf("Instr_dout:0x%x npc_in:0x%x", Instr_dout, npc_in)};

  endfunction

  virtual function void add_to_wave(int transaction_viewing_stream_h);
    //if(transaction_view_h == 0)
    int transaction_view_h;
    transaction_view_h=$begin_transaction(transaction_viewing_stream_h, "decode_in_transaction", start_time);
    //super.add_to_wave(transaction_view_h);
    $add_attribute(transaction_view_h, Instr_dout, "Instr_dout");
    $add_attribute(transaction_view_h, npc_in, "npc_in");
    $end_transaction(transaction_view_h, end_time);
    $free_transaction(transaction_view_h);


  endfunction


endclass
