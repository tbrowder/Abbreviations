#!/usr/bin/env raku

use lib <./lib>;
use Opt::Handler;

my %w = get-abbrevs @*ARGS, :clean-dups;
for %w.keys.sort -> $w {
    print "word: '$w' abbrevs:";
    my $abbrevs = %w{$w};
    if $abbrevs {
        say ""; 
        say "  $_" for $abbrevs.words.sort;
    }
    else {
        say " [none]"; 
    }
}

