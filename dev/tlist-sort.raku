#!/usr/bin/env raku

my @w = <blah Bla bl b B2 B C c>;

sub sort-len(@list, :$longest-first) {
    return @list.sort({$^b.chars cmp $^a.chars}).eager if $longest-first;
    @list.sort({$^a.chars cmp $^b.chars}).eager
}

say "1. original list:                    '{@w.raku}'";
say "2. a normal sort:                    '{@w.sort.eager.Array.raku}'";

my @w2 = @w.sort;
my @w3 = sort-len(@w2);
say "2. normal sort, then sort by length: '{@w3.eager.raku}'";

my @w4 = sort-len(@w);
my @w5 = @w4.sort;
say "4. sort by length:                   '{@w4.raku}'";
say "5. sort by length, then normal sort: '{@w5.eager.raku}'";

=finish

say "3. reversed sort: '{@w.sort.reverse.eager.raku}'";
say "4. sort by length: '{sort-len(@w).raku}'";
say "5. sort by length, then reversed: '{sort-len(@w).reverse.eager.raku}'";

say "6. sort by length, longest first: '{sort-len(@w, :longest-first).raku}'";
