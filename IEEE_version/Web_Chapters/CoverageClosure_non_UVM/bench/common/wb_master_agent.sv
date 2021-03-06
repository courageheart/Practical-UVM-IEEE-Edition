//
// Template for UVM-compliant generic master agent
//

`ifndef WB_MASTER_AGENT__SV
 `define WB_MASTER_AGENT__SV


class wb_master_agent extends uvm_agent;
   // ToDo: add uvm agent properties here
   protected uvm_active_passive_enum is_active = UVM_ACTIVE;
   wb_master_seqr mast_sqr;
   wb_master mast_drv;
   wb_master_mon mast_mon;
   typedef virtual wb_master_if mvif;
   mvif mast_agt_if; 
   wb_config mstr_agent_cfg;


   `uvm_component_utils_begin(wb_master_agent)
      `uvm_field_object(mast_sqr, UVM_DEFAULT)
      `uvm_field_object(mast_drv, UVM_DEFAULT)
      `uvm_field_object(mast_mon, UVM_DEFAULT)
      `uvm_field_object (mstr_agent_cfg,UVM_DEFAULT)
   `uvm_component_utils_end

   // ToDo: Add required short hand override method

   function new(string name = "mast_agt", uvm_component parent = null);
      super.new(name, parent);
      mstr_agent_cfg = new;
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mast_mon = wb_master_mon::type_id::create("mast_mon", this);
      if (is_active == get_is_active()) begin
	 $display("Creating master driver and Sequencer");
         mast_sqr = wb_master_seqr::type_id::create("mast_sqr", this);
         mast_drv = wb_master::type_id::create("mast_drv", this);

      end
      if (!uvm_config_db#(mvif)::get(null, this.get_full_name(), "mst_if", mast_agt_if)) begin
         `uvm_fatal("AGT/NOVIF", $sformatf("No virtual interface specified for this agent instance %m: s",get_full_name()))
      end
      uvm_config_db #(mvif)::set(this,"mast_drv","mst_if",mast_agt_if);
      uvm_config_db #(mvif)::set(this,"mast_mon","mon_if",mast_agt_if);

      // Assign Virtual Interfaces

      if (is_active == get_is_active()) begin
	 mast_drv.drv_if = mast_agt_if;
      end
      mast_mon.mon_if = mast_agt_if;

      // Now getting the configuration
      uvm_config_db #(wb_config)::get(null, this.get_full_name(), "mstr_agent_cfg",mstr_agent_cfg);
      if (is_active == get_is_active()) begin
	 mast_drv.mstr_drv_cfg = mstr_agent_cfg;
         mast_sqr.cfg = mstr_agent_cfg;
      end
      mast_mon.mstr_mon_cfg = mstr_agent_cfg;


   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (is_active == get_is_active()) begin
   	 mast_drv.seq_item_port.connect(mast_sqr.seq_item_export);
      end
   endfunction



endclass: wb_master_agent

`endif // WB_MASTER_AGENT__SV

