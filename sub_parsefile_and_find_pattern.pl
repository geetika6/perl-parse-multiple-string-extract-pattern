use strict;
use warnings;
use IO::File;
main (@ARGV);

sub main
{
    my $filename=$ARGV[0];
    my $pattern=$ARGV[1];
    open (my $fh,'<',$filename);
    parsefile_print_word_with_pattern($pattern);
    close $fh;

}
sub parsefile_print_word_with_pattern
{
    my $index;
    my $pattern_reg=shift;
    my $pattern_from="from_instance";
    my $pattern_to="to_instance";
    my $lines=0;
    my $from_flop;
    my $to_flop;
    #my @flop_combi;
    my $flop_val;
    while (<>)
    {
        chomp;
        my $line=$_;
        #print "$line\n";
        my @words=split(/\s+/,$_);
        foreach my $val(@words)
        {
            if (($val=~/$pattern_reg/)&($lines==1))
            {
                $val=~s/$pattern_reg//;
                $from_flop=$val;
            }
            elsif (($val=~/$pattern_reg/)&($lines==2))
            {
                $val=~s/$pattern_reg//;
                $to_flop=$val;
            }
        }

        $lines++ ;#while ($lines<3);
        print "no of line =$lines\n";
        if ($lines==3)
        {
            $lines=0;
            my @flop_combi=($to_flop,$from_flop);
            process_output_file(@flop_combi);
            @flop_combi=();
        }
    }

}
sub process_output_file
{
    my @array=@_;
    #print @array;
    print "to :$array[0]\n";
    print "from :$array[1]\n";
    my $filename="syncflopdump.txt";
    #append denoted by +>>
    open( my $output_file, "+>>", $filename) || die "Couldn't open '".$filename."' for writing because: ".$!;#open for read using <
    #my $output_file=IO::File->new($filename,"w")or error ("CAnnot open file");

    print $output_file "	 // ***The Sync_Flop $array[0] *** \n";
    print $output_file "	 integer rand1 ;\n";
    print $output_file "	 event event_scenario_1 ;\n";
    print $output_file "	 event event_force_1 ;\n";
    print $output_file "	 reg temp_1 ; \n";
    print $output_file "	 always @( $array[0+1] ) \n";
    print $output_file "	 begin \n";
    print $output_file "	 	 ->event_scenario_1 ; \n";
    print $output_file "	 	 rand1 = \$random(rand_seed) ; \n";
    print $output_file "	 	 if((rand1%2 || \$test\$plusargs(\"NO_RAND_FORCE\")) & start_sync_forcing) \n";
    print $output_file "	 	 begin \n";
    print $output_file "	 	 #0 temp_1 =$array[0] ; \n";
    print $output_file "	 	 @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) \n";
    print $output_file "	 	 begin \n";
    print $output_file "	 	 ->event_force_1 ;\n";
    print $output_file "	 	 force $array[0] =temp_1 ;\n";
    print $output_file "	 	 if(verbose >2 || verbose >1 && (\$test\$plusargs(\"VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC\")))\n";
    print $output_file "	 	 \$display(\"SYNC_INFO : Forcing sync flop $array[0] %t\", \$realtime);\n";
    print $output_file "	 	 end \n";
    print $output_file "	 	 @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) \n";
    print $output_file "	 	 begin \n";
    print $output_file "	 	 release $array[0] ; \n";
    print $output_file "	 	 if(verbose >2 || verbose >1 && (\$test\$plusargs(\"VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC\")))\n";
    print $output_file "	 	 \$display(\"SYNC_INFO : Releasing sync flop $array[0] %t\", \$realtime);\n";
    print $output_file "	 	 end \n";
    print $output_file "	 	 end \n";
    print $output_file "	 end\n";
    print $output_file "	\n";

    #last if $.=$start_line +29;
    close $filename;

}


