//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the decode_out signal driving.  It is
//     accessed by the uvm decode_out driver through a virtual interface
//     handle in the decode_out configuration.  It drives the singals passed
//     in through the port connection named bus of type decode_out_if.
//
//     Input signals from the decode_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within decode_out_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:
//
//             configure:
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             initiate_and_get_response:
//                   This task is used to perform signaling activity for initiating
//                   a protocol transfer.  The task initiates the transfer, using
//                   input data from the initiator struct.  Then the task captures
//                   response data, placing the data into the response struct.
//                   The response struct is returned to the driver class.
//
//             respond_and_wait_for_next_transfer:
//                   This task is used to complete a current transfer as a responder
//                   and then wait for the initiator to start the next transfer.
//                   The task uses data in the responder struct to drive protocol
//                   signals to complete the transfer.  The task then waits for 
//                   the next transfer.  Once the next transfer begins, data from
//                   the initiator is placed into the initiator struct and sent
//                   to the responder sequence for processing to determine 
//                   what data to respond with.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import decode_out_pkg_hdl::*;
`include "src/decode_out_macros.svh"

interface decode_out_driver_bfm 
  (decode_out_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute decode_out_driver_bfm partition_interface_xif
  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clock_i;
  tri reset_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri [1:0] W_control_i;
  reg [1:0] W_control_o = 'bz;
  tri  Mem_control_i;
  reg  Mem_control_o = 'bz;
  tri [5:0] E_control_i;
  reg [5:0] E_control_o = 'bz;
  tri [15:0] IR_i;
  reg [15:0] IR_o = 'bz;
  tri [15:0] npc_out_i;
  reg [15:0] npc_out_o = 'bz;

  // INITIATOR mode output signals

  // Bi-directional signals
  

  assign clock_i = bus.clock;
  assign reset_i = bus.reset;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign W_control_i = bus.W_control;
  assign bus.W_control = (initiator_responder == RESPONDER) ? W_control_o : 'bz;
  assign Mem_control_i = bus.Mem_control;
  assign bus.Mem_control = (initiator_responder == RESPONDER) ? Mem_control_o : 'bz;
  assign E_control_i = bus.E_control;
  assign bus.E_control = (initiator_responder == RESPONDER) ? E_control_o : 'bz;
  assign IR_i = bus.IR;
  assign bus.IR = (initiator_responder == RESPONDER) ? IR_o : 'bz;
  assign npc_out_i = bus.npc_out;
  assign bus.npc_out = (initiator_responder == RESPONDER) ? npc_out_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.

  // Proxy handle to UVM driver
  decode_out_pkg::decode_out_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in decode_out_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from decode_out_driver to this BFM
  // ****************************************************************************
  `decode_out_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by decode_out_driver and decode_out_driver_bfm
  // to communicate initiator driven data to decode_out_driver_bfm.           
  `decode_out_INITIATOR_STRUCT
    decode_out_initiator_s decode_out_initiator_struct;
  // Responder macro used by decode_out_driver and decode_out_driver_bfm
  // to communicate Responder driven data to decode_out_driver_bfm.
  `decode_out_RESPONDER_STRUCT
    decode_out_responder_s decode_out_responder_struct;

  // ****************************************************************************              
  // Always block used to return signals to reset value upon assertion of reset
  always @( posedge reset_i )
     begin
       // RESPONDER mode output signals
       W_control_o <= 'bz;
       Mem_control_o <= 'bz;
       E_control_o <= 'bz;
       IR_o <= 'bz;
       npc_out_o <= 'bz;
       // INITIATOR mode output signals
       // Bi-directional signals
 
     end    

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(decode_out_configuration_s decode_out_configuration_arg); // pragma tbx xtf  
    initiator_responder = decode_out_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response( 
       // This argument passes transaction variables used by an initiator
       // to perform the initial part of a protocol transfer.  The values
       // come from a sequence item created in a sequence.
       input decode_out_initiator_s decode_out_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output decode_out_responder_s decode_out_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the decode_out_initiator_struct:
       //   W_control_t W_control ;
       //   E_control_t E_control ;
       //   Mem_control_t Mem_control ;
       //   IR_t IR ;
       //   npc_out_t npc_out ;
       // Members within the decode_out_responder_struct:
       //   W_control_t W_control ;
       //   E_control_t E_control ;
       //   Mem_control_t Mem_control ;
       //   IR_t IR ;
       //   npc_out_t npc_out ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clock_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available input signals listed.
       //      decode_out_responder_struct.xyz = W_control_i;  //    [1:0] 
       //      decode_out_responder_struct.xyz = Mem_control_i;  //     
       //      decode_out_responder_struct.xyz = E_control_i;  //    [5:0] 
       //      decode_out_responder_struct.xyz = IR_i;  //    [15:0] 
       //      decode_out_responder_struct.xyz = npc_out_i;  //    [15:0] 
       //    How to assign a signal, named xyz, from an initiator struct member.   
       //    All available input signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //      W_control_o <= decode_out_initiator_struct.xyz;  //    [1:0] 
       //      Mem_control_o <= decode_out_initiator_struct.xyz;  //     
       //      E_control_o <= decode_out_initiator_struct.xyz;  //    [5:0] 
       //      IR_o <= decode_out_initiator_struct.xyz;  //    [15:0] 
       //      npc_out_o <= decode_out_initiator_struct.xyz;  //    [15:0] 
    // Initiate a transfer using the data received.
    @(posedge clock_i);
    @(posedge clock_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // decode_out_responder_struct.
    @(posedge clock_i);
    @(posedge clock_i);
  endtask        
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  task respond_and_wait_for_next_transfer( 
       // This argument is used to send data received from the initiator
       // back to the sequence item.  The sequence determines how to respond.
       output decode_out_initiator_s decode_out_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input decode_out_responder_s decode_out_responder_struct 
       );// pragma tbx xtf   
  // Variables within the decode_out_initiator_struct:
  //   W_control_t W_control ;
  //   E_control_t E_control ;
  //   Mem_control_t Mem_control ;
  //   IR_t IR ;
  //   npc_out_t npc_out ;
  // Variables within the decode_out_responder_struct:
  //   W_control_t W_control ;
  //   E_control_t E_control ;
  //   Mem_control_t Mem_control ;
  //   IR_t IR ;
  //   npc_out_t npc_out ;
        
  @(posedge clock_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the decode_out_responder_struct.
    @(posedge clock_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clock_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the decode_out_initiator_struct.
    @(posedge clock_i);
    @(posedge clock_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface
