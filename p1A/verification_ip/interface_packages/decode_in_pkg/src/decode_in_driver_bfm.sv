interface decode_in_driver_bfm(decode_in_if bus);
  logic clock_i;
  logic reset_i;
  logic enable_decode_o;
  logic enable_decode_i;
  logic [15:0] Instr_dout_o;
  logic [15:0] Instr_dout_i;
  logic [15:0] npc_in_o;
  logic [15:0] npc_in_i;

  assign clock_i=bus.clock;
  assign reset_i=bus.reset;
  assign enable_decode_i=bus.enable_decode;
  assign Instr_dout_i=bus.Instr_dout;
  assign npc_in_i = bus.npc_in;
  assign bus.Instr_dout=Instr_dout_o;
  assign bus.npc_in=npc_in_o;


  task access(input logic [15:0] Instr_dout, input logic [15:0] npc_in);
    @(posedge clock_i);
    Instr_dout_o=Instr_dout;
    npc_in_o=npc_in;

  endtask


endinterface
