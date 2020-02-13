import decode_in_pkg::*;
interface decode_in_monitor_bfm(decode_in_if bus);
  logic clock_i;
  logic reset_i;
  logic [15:0] npc_in_i;
  //tri [PSR_WIDTH - 1:0] psr_i;
  logic enable_decode_i;
  logic [15:0] Instr_dout_i;

  event go;

  decode_in_pkg::decode_in_monitor proxy;

  assign clock_i = bus.clock;
  assign reset_i = bus.reset;
  assign enable_decode_i = bus.enable_decode;
  assign npc_in_i = bus.npc_in;
  assign Instr_dout_i = bus.Instr_dout;

  task do_monitor(output bit [15:0] npc, output bit [15:0] Instr_d);
    npc = npc_in_i;
    Instr_d = Instr_dout_i;
  endtask

  task wait_for_reset();
    wait(reset_i==0);
    @(posedge clock_i);
  endtask

  task wait_for_num_clocks(input int unsigned count);
    @(posedge clock_i);
    repeat(count-1) @(posedge clock_i);
  endtask

  initial begin
    @go;
    forever begin
      logic [15:0] dout;
      logic [15:0] npc_in;
      @(posedge clock_i);
      if(enable_decode_i == 1'b1)
      begin
        do_monitor(npc_in, dout);
        proxy.notify_transaction(dout, npc_in);
      end
    end
  end

endinterface
