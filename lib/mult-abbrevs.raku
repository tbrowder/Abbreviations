
multi sub get-abbrevs(List @words, 
                      :$warn, 
                      --> List
                     ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    # Return a list of the input words 
    # in addition to their unique shorter abbreviations, if any.

}

multi sub get-abbrevs(Str $words, 
                      :$warn, 
                      --> Str
                     ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    # Return a space-separated string of the input words 
    # in addition to their unique shorter abbreviations, if any.

}

# This is the "master" sub:
multi sub get-abbrevs(%words, 
                      :$warn, 
                      --> Hash
                     ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    # Return a hash of the input words as keys whose value is
    # a space-separated string
    # of their unique shorter abbreviations, if any.
    

    # Get the max number of characters needed.
    # If the number of characters in a word is equal or less,
    # then it has no abbreviation.
    # We always eliminate dups but do't warn about it unless
    # the :warn option is true.
    if 1 {
        die "fix this"
        my %w;
        %w{$_} = 1 for @w;
        @w = %w.keys.sort;
    }

    my $achars = auto-abbreviation @w.join(' ');
    my %w;
    for @w -> $w {
        %w{$w} = '';
        my $nc = $w.chars;
        if $nc <= $achars {
           # no abbreviation
           next;
        }
        my $len = $achars;
        while $len < $nc {
            my $a = $w.substr(0, $len);
            %w{$w} ~= " $a";
            ++$len
        }
    }
    %w;
}

sub auto-abbreviation(Str $string --> UInt) {
    # Given a string consisting of space-separated words, return the minimum number
    # of characters to abbreviate the set.
    # WARNING: Inf is returned if there are duplicate words in the string,
    # so the user is warned to avoid that or catch the error exception.
    # 
    # Source: http://rosettacode.org/?
    return Nil unless my @words = $string.words;
    return $_ if @words>>.substr(0, $_).Set == @words for 1 .. @words>>.chars.max;
    return Inf;
}
