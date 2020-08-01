unit module Abbreviations:ver<0.0.1>:auth<cpan:TBROWDER>;

=begin pod

=head1 NAME

Abbreviations - provides abbreviations for an input set of one or more words


=head1 SYNOPSIS

=begin code :lang<raku>

use Abbreviations;
my $words = 'a ab abcde';
my %abbrevs = abbreviations $words;

=end code

=head1 DESCRIPTION

B<Abbreviations] is a module with one exported multi subroutine, C<abbreviations>,
which takes as input a set of words and returns the original set with added
unique abbreviations for the set.  (Note the input words are also
abbreviations in the context of this module.)

The input word set can be in one of three forms: (1) a string containing the words separated by spaces, (2) a
list, or (3) a hash with the words as keys. Duplicate words will be
automatically eliminated.

One will get the result in the same form as the input set, e.g., a list input
will return a list.
Note the results as string or list will contain
the original words as well as any other valid abbreviated form. The hash returned will have
input words as keys whose value will be ither empty strings for those
keys without a shorter abbreviation or a string of one or more valid but shorter abbreviations for others.

For example, given an input set consisting of the words

    a 
    ab 
    abcde

the list of abbreviations (which incudes the original words) is

    a 
    ab 
    abc    # <== abbreviation for abcde
    abcd   # <== abbreviation for abcde 
    abcde

One can also ask for a hash which will show the abbreviations
attached as a string to the parent word. That result for the previous input
example is

    a     => '', 
    ab    => '',
    abcde => 'abc abcd'

=head1 AUTHOR

Tom Browder <tom.browder@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

multi sub abbreviations(List @words, 
                        :$warn       = 0,
                        :$check-dups = 0,
                        :$return-type where { Str|Hash }
                       ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    # Return a list of the input words 
    # in addition to their unique shorter abbreviations, if any.

}

multi sub abbreviations(Str $words, 
                        :$warn       = 0,
                        :$check-dups = 0,
                        :$return-type where { List|Hash },
                       ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    # Return a space-separated string of the input words 
    # in addition to their unique shorter abbreviations, if any.

    # First convert input to format for the master subs
    my %w = set $words.words;
    %w = abbreviations %w;
    # Then convert return into proper return form for this sub
    my $abbrevs = ''; 
    for %w.kv -> $w, $a {
        $abbrevs ~= ' ' if $abbrevs; # no leading space for the first word 
        $abbrevs ~= $w;
        $abbrevs ~= " $a" if $a;
    }
    $abbrevs;
}

multi sub abbreviations(%words, 
                        :$return-type where { Str|List },
                       ) is export {
}

# Following is the "master" sub. The multis will call it.
sub get-abbrevs($word-set where { Str|List|Hash }, 
                :$warn        = 0,
                :$check-dups  = 0,
                # make the return type different from the input set type
                :$return-type where { Str|List|Hash },
               ) {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word. 

    my $input-str;
    my $input-typ;
    if $word-set ~~ Str {
        $input-str = $word-set;
    }
    elsif $word-set ~~ List {
        $input-str = $word-set.sort.join(' ');
    }
    elsif $word-set ~~ Hash {
        $input-str = $word-set.keys.sort.join(' ');
    }
    else {
        die "FATAL: Cannot handle word set format '{$word-set.^name}'";
    }
   
    # Return a hash of the input words as keys whose value is
    # a space-separated string
    # of their unique shorter abbreviations, if any.
    
    # Get the max number of characters needed to have a unique abbreviation.
    # If the number of characters in a word is equal or less,
    # then it has no abbreviation.
    my $max-chars = auto-abbreviation $input-str;

    # prepare the desired output
    my %ow;
    my @ow;
    my $ow = '';
    for $input-str.words.sort -> $w {
        %ow{$w} = '';
        my $nc = $w.chars;
        if $nc <= $max-chars {
            # no abbreviation
            if $word-set ~~ Str {
                $ow ~= ' ' if $ow;
                $ow ~= $w;
            }
            elsif $word-set ~~ List {
                @ow.push: $w;
            }
            next;
        }

        # handle the abbreviations
        my $len = $max-chars;
        while $len < $nc {
            my $a = $w.substr(0, $len);
            if $word-set ~~ Str {
                $ow ~= ' ' if $ow;
                $ow ~= $w;
            }
            elsif $word-set ~~ List {
                @ow.push: $w;
            }
            elsif $word-set ~~ Hash {
                %ow{$w} ~= " $a";
                @ow.push: $w;
            }
     
            ++$len
        }
    }
    # the return depends on the input type
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
