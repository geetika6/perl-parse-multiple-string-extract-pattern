
#Perl Problems:


*Here is the force-sync problem statement.*

###### Sync list format - Search and replace pattern in the file*

```
from_instance: u_mti_loc_to_aurora_data_cdc/cdc_adclane1/wptr_gray_reg[2] 
to_instance: u_mti_loc_to_aurora_data_cdc/cdc_adclane1/wptr_gray_d1_reg[2] 
```

A script needs to be written that parses the sync list file with above format, extracts out each instance of sync flop and dumps the code for force-sync in the following format.

```
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

```

1.Initial approach
*Extract the relevant source , destination flop and the clock which have to be provided to the dumping/print subroutine*

2.Final Approach used:
* Use the extracted input to make a final file
* writing the file in append mode to add text below for each flop.

**Commands to run:**

```
perl parse_multiplefile_extract_pattern.pl sync.lst flop_clk.txt _reg clk
```

