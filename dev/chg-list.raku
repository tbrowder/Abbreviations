#!/usr/bin/env raku

my @w = <blah Bla bl b B2 B C c>;

say "original list: '{@w.raku}'";
@w .= sort;
say "after a normal sort: '{@w.raku}'";

$_.=lc for @w;
say "after a lower-casing: '{@w.raku}'";


