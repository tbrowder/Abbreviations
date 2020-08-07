#!/usr/bin/env raku

use lib <../lib>;
use Abbreviations :auto;

my $inp = @*ARGS.shift;

my $w = $inp.defined ?? $inp !! '';

my $n = auto-abbreviate($w);
if $n === Inf {
    die "FATAL: \$w is empty";
}
note "Given word string '$w'";
note "  max-chars = '$n'";
