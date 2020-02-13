interface decode_in_if   #(
      int NPC_WIDTH = 16,
      //int PSR_WIDTH = 3,
      int INSTR_WIDTH = 16
      ) 
  (
    input tri clock,
    input tri reset, 
    input tri enable_decode, 
    //input tri [PSR_WIDTH - 1:0] psr, 
    inout tri [INSTR_WIDTH - 1:0] Instr_dout,
    inout tri [NPC_WIDTH - 1:0] npc_in
  );

endinterface 

