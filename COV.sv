class dram_cov #(type T=dram_seq_item) extends uvm_subscriber #(T);
`uvm_component_utils(dram_cov)
//dram_seq_item pkt;
T pkt;
real cov;

covergroup CovPort;	//@(posedge intf.clk);
  address : coverpoint pkt.add {
    bins low[]    = {[0:31]};
    bins med[]    = {[32:63]};
//    bins high[]   = {[43:63]};
  }
  data : coverpoint  pkt.data_in {
    bins low[]    = {[0:127]};
    bins med[]    = {[128:255]};
  //  bins high[]   = {[151:255]};
  }

  enable: coverpoint pkt.en {
   bins en_low = {0};
   bins en_high = {1};
 }
 write: coverpoint pkt.wr {
   bins wr_low = {0};
   bins wr_high = {1};
 }
endgroup



function new (string name = "dram_cov", uvm_component parent);
      super.new (name, parent);
	  CovPort = new;
endfunction


	  
virtual function void write (T t);
	`uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
	pkt = t;
	CovPort.sample();
endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=CovPort.get_coverage();
  endfunction


      function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
endclass
