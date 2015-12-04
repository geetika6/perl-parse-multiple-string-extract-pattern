#!/usr/bin/env perl

use warnings;
use strict;

    my $filename=$ARGV[0];
    open (DATA,'<',$filename);
while ( <DATA> ) {
    #s/(\d+).*$/$1/ && print;
    s/_reg// && print;
}
