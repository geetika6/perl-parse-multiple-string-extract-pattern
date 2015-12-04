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
    #parsefile_process_word_with_pattern();
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
    my @flop_combi;
    my $flop_val;
    while (<>)
    {
        chomp;
        my $line=$_;
        #print "$line\n";
        my @words=split(/\s+/,$_);
        #print @words;
        #for ($index=0,$index<=scalar @words,$index++)
        #{
        #        print $index,"\n";
        #    if ($words[$index]=~/$pattern/)
        #    {
        #         $words[$index]=~s/$pattern//;
        #         print "$words[$index]\n";

        #     }
        #}




        foreach my $val(@words)
        {
            if (($val=~/$pattern_reg/)&($lines==1))
            {
                #$val=shift @words;
                #print "shift $val";
                $val=~s/$pattern_reg//;
                $from_flop=$val;
                #print "from flop=$from_flop\n";
            }
            elsif (($val=~/$pattern_reg/)&($lines==2))
            {
                $val=~s/$pattern_reg//;
                $to_flop=$val;
                #print "to flop =$to_flop\n";
                #print "from flop=$from_flop\n";
            }
            else
            {
                #print "no match for reg\n";
            }
        }

        #while (@words)
        #{
        #    while
        #}
        #print @words."\n";


        $lines++ ;#while ($lines<3);
        print "no of line =$lines\n";
        if ($lines==3)
        {
            $lines=0;
            my $flop_no++;
            my $flop_line_no=$flop_no*30;
            print "flop line no =$flop_line_no \n ";
            @flop_combi=($to_flop,$from_flop,$flop_line_no);
            process_final_output(@flop_combi);
            foreach $flop_val(@flop_combi)
            {
                print "total flop combi-for/to =$flop_val\n";
            }
            @flop_combi=();
        }
    }

}
sub parsefile_process_word_with_pattern
{
    my $pattern=$ARGV[1];
    while (<>)
    {
        my $lines++;
        chomp;
        my $line=$_;
        print "$line\n";
        my @words=split(/\s+/,$_);
        #foreach my $val(@words)
        #{
        #    if ($val=~/$pattern/)
        #    {
        #        parsefile_print_word_with_patternint "$val\n";


        #    }
        #}
        for (my $index=0;$index<=scalar @words;$index=$index+2)
        {
            #$words[$index]=~s/_reg//;
            print "$words[$index]\n";
            #$words[$index+1]=~s/_reg//;
            #print "$words[$index+1]\n";
            if ($words[$index]=~/$pattern/)
            {
                $words[$index]=~s/$pattern//;
                print "$words[$index]\n";
            }
            # if ($words[$index+1]=~/$pattern/)
            #     {
            #         my $destination_flop=substr($words[$index+1],-7);
            #     }
        }
        #while (@words)
        #{
        #    while
        #}
        print @words."\n";

    }

}
sub process_final_output
{
    my @array=@_;
    #print @array;
    print "to :$array[0]\n";
    print "from :$array[1]\n";
    my $start_line=$array[2];
    my $filename="syncflopdump.txt";
    open( my $final, ">", $filename) || die "Couldn't open '".$filename."' for writing because: ".$!;#open for read using <
# my $final=IO::File->new($filename,"w")or error ("CAnnot open file");
while(<>)
{
$.=$start_line;

        print $final "	 // ***The Sync_Flop $array[0] *** \n";
        print $final "	 integer rand1 ;\n";
        print $final "	 event event_scenario_1 ;\n";
        print $final "	 event event_force_1 ;\n";
        print $final "	 reg temp_1 ; \n";
        print $final "	 always @( $array[0+1] ) \n";
        print $final "	 begin \n";
        print $final "	 	 ->event_scenario_1 ; \n";
        print $final "	 	 rand1 = \$random(rand_seed) ; \n";
        print $final "	 	 if((rand1%2 || \$test\$plusargs(\"NO_RAND_FORCE\")) & start_sync_forcing) \n";
        print $final "	 	 begin \n";
        print $final "	 	 #0 temp_1 =$array[0] ; \n";
        print $final "	 	 @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) \n";
        print $final "	 	 begin \n";
        print $final "	 	 ->event_force_1 ;\n";
        print $final "	 	 force $array[0] =temp_1 ;\n";
        print $final "	 	 if(verbose >2 || verbose >1 && (\$test\$plusargs(\"VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC\")))\n";
        print $final "	 	 \$display(\"SYNC_INFO : Forcing sync flop $array[0] %t\", \$realtime);\n";
        print $final "	 	 end \n";
        print $final "	 	 @(posedge testbench.top.u_mti_loc_to_aurora_data_cdc.cdc_adclane1.rd_clk ) \n";
        print $final "	 	 begin \n";
        print $final "	 	 release $array[0] ; \n";
        print $final "	 	 if(verbose >2 || verbose >1 && (\$test\$plusargs(\"VERBOSE_U_MTI_LOC_TO_AURORA_DATA_CDC\")))\n";
        print $final "	 	 \$display(\"SYNC_INFO : Releasing sync flop $array[0] %t\", \$realtime);\n";
        print $final "	 	 end \n";
        print $final "	 	 end \n";
        print $final "	 end\n";
        print $final "	\n";

        #last if $.=$start_line +29;
        close $filename;

}
}


