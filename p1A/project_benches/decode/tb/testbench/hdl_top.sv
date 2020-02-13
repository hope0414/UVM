import uvm_pkg::*;
module hdl_top();


  logic clk;

  initial begin: clk_gen
    clk = 1'b0;
    #20;
    forever begin
    #5;
    clk =~clk;
    end
  end

  logic reset;
  initial begin: rst_gen
    reset = 1'b1;
    #30;
    reset = 1'b0;
  end

  logic enable_decode;
  initial begin
    enable_decode = 1'b0;
    #30;
    enable_decode = 1'b1;
 
  end

  wire [15:0] dout, npc_in;
  bit enable_transaction_viewing = 1'b1;
  bit is_active = 1'b1;
  bit en_cov = 1'b1;
  decode_in_if decode_in_bus(.clock(clk), .reset(reset), .enable_decode(enable_decode), .Instr_dout(dout), .npc_in(npc_in));

  decode_in_monitor_bfm mon_bfm(decode_in_bus);
  decode_in_driver_bfm drv_bfm(decode_in_bus);

  initial begin

  uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, "uvm_test_top.configuration", "decode_in", mon_bfm);

  uvm_config_db#(virtual decode_in_driver_bfm)::set(null, "uvm_test_top.configuration", "decode_in", drv_bfm);

  uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "wave", enable_transaction_viewing);

  uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "active", is_active);

  uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "coverage", en_cov);

  end


endmodule
