Perl Problems:
1]Here is the force-sync problem statement.

Sync list format that we get from IP:

---------------------------------------------------
from_instance: u_mti_loc_to_aurora_data_cdc/cdc_adclane1/wptr_gray_reg[2] 
to_instance: u_mti_loc_to_aurora_data_cdc/cdc_adclane1/wptr_gray_d1_reg[2] 
---------------------------------------------------


A script needs to be written that parses the sync list file with above format, extracts out each instance of sync flop and dumps the code for force-sync in the following format.

  // ***The Sync_Flop testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  ***  
  integer rand1 ;
  event event_scenario_1 ;
  event event_force_1 ;
  reg temp_1 ; 
  always @( testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray[2]  )  
  begin  
  	 ->event_scenario_1 ;  
  	 rand1 = $random(rand_seed) ; 
  	 if((rand1%2 || $test$plusargs("NO_RAND_FORCE")) & start_sync_forcing) 
  	 begin 
  	   #0 temp_1 =testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  ; 
  	   @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) 
  	   begin 
  	    ->event_force_1 ;
  	     force testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  =temp_1 ;
  	     if(verbose >2 || verbose >1 && ($test$plusargs("VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC")))
  	       $display("SYNC_INFO : Forcing sync flop testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  %t", $realtime);
  	   end 
  	   @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) 
  	   begin 
  	     release testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  ; 
  	     if(verbose >2 || verbose >1 && ($test$plusargs("VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC")))
  	       $display("SYNC_INFO : Releasing sync flop testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.wptr_gray_d1[2]  %t", $realtime);
  	   end 
  	 end   
  end



 # Approach used:
 # Parse line by line 0,1,2 and extract the 2 element array contain 1 source and 1 destination flop and pass it
 # to a subroutine to print in the desired fashion
 #writing the file in append mode to add text below for each flop.
 
 2]Read ethernet packet and reverse byte by byte like
 data:
 55555555555555d5
 f0f1f2f3f4f5f6f7
 
 Final output
 d555555555555555
 f7f6f5f4f3f2f1f0
 
 Approach :
 Divide into 2character elements inside an array, reverse and join removing spaces
 

