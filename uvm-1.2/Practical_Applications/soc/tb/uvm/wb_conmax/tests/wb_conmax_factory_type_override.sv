/***********************************************
 *                                              *
 * Examples for the book Practical UVM          *
 *                                              *
 * Copyright Srivatsa Vasudevan 2010-2016       *
 * All rights reserved                          *
 *                                              *
 * Permission is granted to use this work       * 
 * provided this notice and attached license.txt*
 * are not removed/altered while redistributing *
 * See license.txt for details                  *
 *                                              *
 ************************************************/

`ifndef WB_CONMAX_FACTORY_TYPE_OVERRIDE_SV
 `define WB_CONMAX_FACTORY_TYPE_OVERRIDE_SV

typedef class wb_conmax_base_test;

class wb_conmax_factory_type_override_test extends wb_conmax_base_test;

   `uvm_component_utils(wb_conmax_factory_type_override_test)

   sequence_1 seq1;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      // Using the uvm_coreservice_t:
      uvm_coreservice_t cs;
      uvm_root r;
      uvm_factory fact;
      super.build_phase(phase);
      // uvm_config_db #(wb_config)::set(null,$sformatf("uvm_test_top.env.master_agent[%02d]",i),"mstr_agent_cfg",master_configs[i] );

      cs = uvm_coreservice_t::get();
      r = cs.get_root();
      fact = cs.get_factory();
      fact.set_type_override_by_type(wb_master_agent::get_type(),wb_master_agent_n::get_type(),1);
      fact.print();
      // Set the default sequencer in all the master agents
      uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent[00].mast_sqr.main_phase", "default_sequence", sequence_1::get_type()); 
      
      r.enable_print_topology=1;
      r.print_topology();	
   endfunction




   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this,"Test Main Objection");
      seq1 = sequence_1::type_id::create("sequence_1",this);
      seq1.start(env.master_agent[00].mast_sqr,null);
      seq1.wait_for_sequence_state(UVM_FINISHED);
      phase.drop_objection(this,"Dropping Test Main Objection");
   endtask

endclass :  wb_conmax_factory_type_override_test

`endif //WB_CONMAX_FACTORY_TYPE_OVERRIDE_SV

