#!/usr/bin/env raku

my @w = <blah Bla bl b B2 B C c>;

sub sort-list(@list, :$longest-first) {
    return @list.sort({$^b.chars cmp $^a.chars}) if $longest-first;
    @list.sort({$^a.chars cmp $^b.chars})
}


say "original list: '{@w.raku}'";
@w .= sort;
say "after a normal sort: '{@w.raku}'";

say "reversed sort: '{@w.sort.reverse.raku}'";
say "sort by length: '{@w.sort({$^a.chars cmp $^b.chars}).raku}'";
say "sort by length reversed: '{@w.sort({$^a.chars cmp $^b.chars}).reverse.raku}'";

say "sort by length: '{sort-list(@w).raku}'";
say "sort by length, longest first: '{sort-list(@w, :longest-first).raku}'";

