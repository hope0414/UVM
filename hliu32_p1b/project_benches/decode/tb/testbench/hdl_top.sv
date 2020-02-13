import uvm_pkg::*;
import uvmf_base_pkg::*;
import uvmf_base_pkg_hdl::*;
import decode_test_pkg::*;
module hdl_top();


  logic clk=0;

  logic reset;
  initial begin: rst_gen
    reset = 1'b1;
    #20;
    reset = 1'b0;
  end

  always #5 clk = ~clk;

  decode_in_if decode_in_bus(.clock(clk), .reset(reset));

  decode_in_monitor_bfm mon_bfm(decode_in_bus);
  decode_in_driver_bfm drv_bfm(decode_in_bus);

  decode_out_if decode_out_bus(.clock(clk), .reset(reset));
  decode_out_monitor_bfm mon_bfm_o(decode_out_bus);

  Decode DUT(
	  .clock(clk),
	  .reset(reset),
	  .enable_decode(decode_in_bus.enable_decode),
	  .dout(decode_in_bus.dout),
	  .npc_in(decode_in_bus.npc_in),
	  .W_Control(decode_out_bus.W_control),
	  .Mem_Control(decode_out_bus.Mem_control),
	  .E_Control(decode_out_bus.E_control),
	  .IR(decode_out_bus.IR),
	  .npc_out(decode_out_bus.npc_out)
  );

  initial begin

  uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in", mon_bfm);

  uvm_config_db#(virtual decode_in_driver_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_in", drv_bfm);

  uvm_config_db#(virtual decode_out_monitor_bfm)::set(null, UVMF_VIRTUAL_INTERFACES, "decode_out", mon_bfm_o);
  //uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "wave", enable_transaction_viewing);

  //uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "active", is_active);

  //uvm_config_db#(bit)::set(null, "uvm_test_top.configuration", "coverage", en_cov);

  end


endmodule
