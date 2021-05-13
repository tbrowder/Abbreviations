#!/usr/bin/env raku

=begin comment
  %words-in - make a hash of the original words with empty values

  %m - make an empty, master hash for the final result.

  %w - make a working hash of first characters (key length = 1)
       with values a list of those words with that leading character.
=end comment

# trying a new algorithm based on more brute force:
# sort the list, then, find the min abbrev between each
# pair, tossing the first as complete, go to the next pair.

my @words-in = <blah Bla bl b B2 B C c>; # keep the original order
say "original list: '{@words-in.raku}'";
my @w = @words-in;

# sort
@w .= sort;
say "after a default sort: '{@w.raku}'";
# sort by length
@w .= sort({$^b.chars cmp $^a.chars}); # longest first
say "then after a sort by length (longest first): '{@w.raku}'";

# make a hash of the input words
my %words-in;

# keep track of unique, shortest keys and their word
# the master hash
my %m; 

# create the 1-char key, working hash
my %w;
my $max-word-len = init-one-char-key-hash @words-in, %w;

my $klen = 2;
while $klen <= $max-word-len and %w.elems {
    my (%g1, %g2) = split-group %w, $klen;
    if %g1.elems {
        # append to the master hash
        %m.append: %g1;
    }
    %w = %g2;
    ++$klen; 
}

say "the final hash: '{%m.raku}'";

##### subroutines #####
sub init-one-char-key-hash(@w, %g --> Int) {
    # separate words into groups by first char of the word
    # returns the max word length found
    my $max = 0;
    for @w -> $w {
        my $wlen = $w.chars;
        $max = $wlen if $wlen > $max;
        my $f = $w.comb[0];
        if %g{$f}:exists {
            %g{$f}.push: $w;
        }
        else {
            %g{$f} = [];
            %g{$f}.push: $w;
        }
    }
    $max
}

sub split-group(%g, $key-len --> List) {
    my \N = $key-len; 
    # Given a hash keyed on N-char strings with a value of a list of one or
    # more words with the N-char string as leading characters, split the
    # hash into two groups: group one is the same but with only a single word per key,
    # while group two has keys of N+1 chars.
    # Return the two hashes.

    my (%g1, %g2);

    GROUP: for %g.kv -> $k, @v {
        my $klen = $k.chars;
        die "FATAL: input key '$k' is not of length {N}" if $klen != N-1;
        if @v.elems == 1 {
            my $w = @v[0];
            if %g1{$k}:exists {
                die "FATAL: key '$k', length $klen, is unexpectedly used!" 
            }
            else {
                %g1{$k} = [];
                %g1{$k}.push: $w;
            }
            next GROUP;
        }

        WORD: for @v -> $w {
            # we need the new key
            my $K = $w.substr(0, N);
            if %g2{$K}:exists {
                %g2{$K}.push: $w;
            }
            else {
                %g2{$K} = [];
                %g2{$K}.push: $w;
            }
            next WORD;
        }
    }

    # empty the input hash
    %g = [];

    # return the new, possibly empty hashes
    %g1, %g2
}

=finish
my @c = @w.sort;
say "after a normal sort: '{@c.raku}'";
# sort by length
@c .= sort({$^a.chars cmp $^b.chars}); # shortest first
say "then after a sort by length (shortest first): '{@c.raku}'";
@c .= sort({$^b.chars cmp $^a.chars}); # longest first
say "then after a sort by length (longest first): '{@c.raku}'";

my %g; # holds original groups
my %G; # holds groups of finished abbrevs

# first separate into groups by first char of the word
for @c -> $w {
    my $f = $w.comb[0];
    if %g{$f}:exists {
        %g{$f}.push: $w;
    }
    else {
        %g{$f} = [];
        %g{$f}.push: $w;
    }
}

while %g.elems {
    my (%g1, %g2) = split-group %g;
    %G.append: %g1;
    %g = %g2;
}

say "the final hash: '{%G.raku}'";

sub split-group(%g, --> List) {
    # Given a hash keyed on N-char strings with a value of a list of one or
    # more words with the N-char string as leading characters, split the
    # hash into two groups: group one is the same but with only a single word per key,
    # while group two has keys of not N chars.
    # Return the two hashes.

    my (%g1, %g2);

    GROUP: for %g.kv -> $k, @v {
        if @v.elems == 1 {
            my $w = @v[0];
            if %g1{$k}:exists {
                %g1{$k}.push: $w;
            }
            else {
                %g1{$k} = [];
                %g1{$k}.push: $w;
            }
            next GROUP;
        }

        WORD: for @v -> $w {
            my $wlen = $w.chars;
            # if the new word is too long, add it back to %g1
            if $wlen == $nc {
                if %g1{$k}:exists {
                    %g1{$k}.push: $w;
                }
                else {
                    %g1{$k} = [];
                    %g1{$k}.push: $w;
                }
                next WORD;
            }

            my $new-key = $w.substr(0, $nc2);
            if %g2{$new-key}:exists {
                %g2{$new-key}.push: $w;
            }
            else {
                %g2{$new-key} = [];
                %g2{$new-key}.push: $w;
            }
        }
    }

    # empty the input hash
    %g = [];

    # return the new, possibly empty hashes
    %g1, %g2
}


