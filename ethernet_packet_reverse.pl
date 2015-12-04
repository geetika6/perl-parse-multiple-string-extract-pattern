use strict;
use warnings;
use IO::File;
main (@ARGV);

sub main
{
    reverse_packet();

}
sub reverse_packet
{
    my $filename=$ARGV[0];
    my $filename1="packet_final.hex";
    open (FILE, $ARGV[0]) or die "Can't open '$ARGV[0]': $!";
    open( my $output_file, ">", $filename1) || die "Couldn't open '".$filename1."' for writing because: ".$!;
    while (<FILE>)
    {
        #chomp;
        my $line=$_;
        my @output;

        #$line=reverse($line);
        while ($line =~ /(.{2})/g) {
            push @output, $1;
        }
        @output=reverse(@output);
        #foreach my $val(@output)
        #{
        #$val=~s/\s+//;
        #   print "$val\n";
        #}
        @output=join ("",@output);
        foreach my $val(@output)
        {
            print $output_file "$val\n";
        }
        #my @words=split(/\s+/,$_);
    }

    close FILE;
}
