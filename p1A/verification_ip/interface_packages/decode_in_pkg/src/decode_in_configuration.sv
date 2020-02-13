class decode_in_configuration extends uvm_object;

  `uvm_object_utils(decode_in_configuration)
  virtual decode_in_monitor_bfm mon_bfm;
  virtual decode_in_driver_bfm drv_bfm;

  bit enable_transaction_viewing;
  bit is_active;
  bit en_cov;

  function new(string name="decode_in_configuration");
    super.new(name);
  endfunction

  virtual function void initialize(string name, bit is_active, string path_to_agent);
    uvm_config_db#(decode_in_configuration)::set(null, path_to_agent,"cfg",this);
  endfunction

  virtual function string convert2string();
    return {super.convert2string};
  endfunction


endclass
