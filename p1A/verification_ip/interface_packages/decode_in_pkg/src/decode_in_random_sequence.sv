class decode_in_random_sequence extends uvm_sequence #(decode_in_transaction);

  decode_in_transaction trans;
  `uvm_object_utils(decode_in_random_sequence)

  function new(string name = "decode_in_random_sequence");
    super.new(name);
    
  endfunction

  virtual task body();
    
    trans = new("trans");
    repeat(25) begin
      start_item(trans);
      assert(trans.randomize());
      finish_item(trans);
    end

  endtask
endclass
