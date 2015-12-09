use strict;
use warnings;
use IO::File;
main (@ARGV);

sub main
{
    #my $pattern=$ARGV[2];
    sub_read_multiple_file();
    #parsefile_print_word_with_pattern($pattern);
    #close $fh;

}
sub sub_read_multiple_file
{
    my $inputFile1 = $ARGV[0];
    my $inputFile2 = $ARGV[1];
    my $patternreg=$ARGV[2];
    my $patternclk=$ARGV[3];
    my $IN1FILE;
    my $IN2FILE;
    open($IN1FILE,"<","$inputFile1") or die "cant open file";
    open($IN2FILE,"<","$inputFile2") or die "cant open file";
    #while (!eof $IN1FILE and !eof $IN2FILE)
    while (!eof $IN1FILE and !eof $IN2FILE )
    #while (<IN1FILE>)
    {
        my @a1=readfile_3line_parse_pattern($IN1FILE,$patternreg);
        print "2 flop=@a1\n";
        my $a3=readfile_1line_parse_pattern($IN2FILE,$patternclk);
        print "clock =$a3\n";
        #my $line1 = <IN1FILE>;
        #my $line2 = <IN2FILE>;
    }
    print "out of while loop\n";
}

sub readfile_1line_parse_pattern
{
    my $lines=0;
    my $IN2FILE=shift;
    my $clock_flop;
    my $pattern_reg= shift;
    #my $inputFile2 = $ARGV[1];
    #my @flop_combi;
    while ($_=<$IN2FILE>)
    {
        chomp;
        my $line=$_;
        #my @words=split(/\s+/,$_);
        if ($line=~/$pattern_reg/)
        {
            $clock_flop=$line;
            return $clock_flop;
        }
    }

    $lines++ ;
}
sub readfile_3line_parse_pattern

{
    my $lines=0;
    my $IN1FILE=shift;
    my $from_flop;
    my $to_flop;
    my $pattern_reg= shift;
    #my @flop_combi;
    #while (<>)
    while ($_=<$IN1FILE>)
    {
        chomp;
        my $line=$_;
        my @words=split(/\s+/,$_);
        #print "$line\n";
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
        if ($lines==3)
        {
            $lines=0;
            my @flop_combi=($to_flop,$from_flop);
            #process_output_file(@flop_combi);
            return @flop_combi;
            @flop_combi=();
        }
    }

}
