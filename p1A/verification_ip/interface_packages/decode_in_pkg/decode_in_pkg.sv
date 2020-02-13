package decode_in_pkg;

  import uvm_pkg::*;
  //import questa_uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "./src/typedef.svh"
  `include "./src/decode_in_transaction.sv"
  `include "./src/decode_in_random_sequence.sv"
  `include "./src/decode_in_coverage.sv"
  `include "./src/decode_in_driver.sv"
  //`include "./src/decode_in_driver_bfm.sv"
  `include "./src/decode_in_monitor.sv"
  //`include "./src/decode_in_monitor_bfm.sv"
  `include "./src/decode_in_sequencer.sv"
  `include "./src/decode_in_configuration.sv"
  `include "./src/decode_in_agent.sv"
  //`include "./src/decode_in_if.sv"



endpackage
