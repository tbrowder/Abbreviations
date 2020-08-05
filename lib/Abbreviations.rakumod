unit module Abbreviations:ver<0.0.1>:auth<cpan:TBROWDER>;

=begin pod

=head1 NAME

Abbreviations - provides abbreviations for an input set of one or more words

=head1 SYNOPSIS

=begin code :lang<raku>

use Abbreviations;
my $words = 'a ab abcde';
# The main exported routine:
my %abbrevs = abbreviations $words;

=end code

There are two shorter routine name abbreviations one can use that are always exported:

=begin code :lang<raku>
 abbrevs
 abbrev
=end code

In the sprit of the module, one can C<use Abbreviations :ALL;>
and have these additional short forms are available:

=begin code :lang<raku>
 abbre
 abbr
 abb
 ab
 a
=end code

Each of those is individually available by adding its name as an adverb, e.g.:

=begin code :lang<raku>

use Abbreviations :abb;
my %abb = abb $words;

=end code


=head1 DESCRIPTION

B<Abbreviations> is a module with one exported multi subroutine,
C<abbreviations>, which takes as input a set of words and returns the
original set with added unique abbreviations for the set.  (Note the
input words are also abbreviations in the context of this module.)

A B<word> satisfies the Raku regex: C<$word ~~ /\S+/> which is quite
loose. Using programs can of course further restrict that if need
be. For example, for use with module B<Opt::Handler> words must
satisfy this regex: C<$word ~~ /<ident>/>.

The input word set can be in one of three forms: (1) a string
containing the words separated by spaces, (2) a list, or (3) a hash
with the words as keys. Duplicate words will be automatically
eliminated, but you can use the ':warn' option if you want to be
notified.

One will normally get the result as a C<Hash>, but the return type can be
specified if desired.  Note the results as C<Str> or C<List> will contain
the original words as well as any other valid abbreviated form. The
C<Hash> returned will have input words as keys whose value will be either
empty strings for those keys without a shorter abbreviation or a
string of one or more valid but shorter abbreviations for others.

For example, given an input set consisting of the words

=begin code
a
ab
abcde
=end code

the list of abbreviations (which incudes the original words) is

=begin code
    a
    ab
    abc    # <== abbreviation for abcde
    abcd   # <== abbreviation for abcde
    abcde
=end code

The default hash returned which will show the abbreviations attached
as a string to the parent word. That result for the previous input
example is

    a     => '',
    ab    => '',
    abcde => 'abc abcd'

=head1 AUTHOR

Tom Browder <tom.browder@gmail.com>

=head1 CREDITS

=item Leon Timmermans (aka @Leont) for inspiration from his Raku module C<Getopt::Long>.

=item @Thundergnat, the original author of the Raku C<auto-abbreviate> algorithm on L<Rosetta Code|http://rosettacode.org/wiki/Abbreviations,_automatic#Raku>.

=item The Raku community for help with subroutine signatures.

=head1 COPYRIGHT AND LICENSE

Copyright &#x00A9; 2020 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

=end pod

sub check-type($arg, Str :$valid-types! where {/Str|List|Hash/}  --> Pair) {
    # Given an arg of unknown type and
    # a string with one or more desired type names as words
    # from the set [Str List Hash],
    # return the type found as a pair with the type name as
    # key and validity (True or False) as value.
    my $typ = $arg.^name;
    if $typ ~~ /$valid-types/ {
        return $typ => True;
    }
    return $typ => False;
}

sub check-dups($words where Str|List --> Str) {
    # The input is either a Str or a List.
    # The return is a sorted string for input into auto-abbrev.
    my @w;
    given $words {
        when Str {
            @w = $_.words;
        }
        when List {
            @w = $_;
        }
        default {
            die "Unhandled input type '{$words.^name}'";
        }
    }

    my %w;
    my @dups;
    for @w -> $w {
        if %w{$w}:exists {
            @dups.push: $w;
            next;
        }
        %w{$w} = True;
    }

    if @dups.elems {
        note "WARNING: Found the following duplicate words:";
        note "  $_" for @dups.sort;
    }

    return %w.keys.sort.join(' ');
} # end sub

# define  "aliases" for convenience
our &abbrevs is export         = &abbreviations;
our &abbrev  is export         = &abbreviations;
our &abbre   is export(:abbre) = &abbreviations;
our &abbr    is export(:abbr)  = &abbreviations;
our &abb     is export(:abb)   = &abbreviations;
our &ab      is export(:ab)    = &abbreviations;
our &a       is export(:a)     = &abbreviations;
sub abbreviations($word-set where Str|List|Hash,
                  :$warn = 0,
                  # Make the return type different from the input set
                  # type but only if the return type is different:
                  :$return-type where {/Str|List|Hash|Default/} = 'Default',
                 ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word.

    my Str $abbrev-str;
    my $in-typ;
    my $out-typ;
    if $word-set ~~ Str {
        $abbrev-str = $word-set;
        $in-typ = 'Str';
        $abbrev-str = check-dups($abbrev-str) if $warn;

        # determine output type
        if $return-type ne 'Default' {
            die "Tom, fix this";
        }
        else {
            $out-typ = $in-typ;
        }
    }
    elsif $word-set ~~ List {
        $abbrev-str = $word-set.sort.join(' ');
        $in-typ = 'List';
        $abbrev-str = check-dups($abbrev-str) if $warn;

        # determine output type
        if $return-type ne 'Default' {
            die "Tom, fix this";
        }
        else {
            $out-typ = $in-typ;
        }
    }
    elsif $word-set ~~ Hash {
        $abbrev-str = $word-set.keys.sort.join(' ');
        $in-typ = 'Hash';

        # determine output type
        if $return-type ne 'Default' {
            die "Tom, fix this";
        }
        else {
            $out-typ = $in-typ;
        }
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
    my $max-chars = auto-abbreviate $abbrev-str;

    # prepare the desired output
    my %ow;
    my @ow;
    my $ow = '';
    for $abbrev-str.words.sort -> $w {
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
        while $len <= $nc {
            my $a = $w.substr(0, $len);
            if $word-set ~~ Str {
                $ow ~= ' ' if $ow;
                $ow ~= $a;
            }
            elsif $word-set ~~ List {
                @ow.push: $a;
            }
            # Hashes need extra attention because the key (the primary
            # word) is already in the output set
            elsif $word-set ~~ Hash and $len < $nc {
                %ow{$w} ~= ' ' if %ow{$w};
                %ow{$w} ~= $a;
            }
            ++$len;
        }
    }

    # the return depends on the input type by default
    if $in-typ eq $out-typ {
        if $word-set ~~ Str {
            return $ow;
        }
        elsif $word-set ~~ List {
            return @ow;
        }
        elsif $word-set ~~ Hash {
            return %ow;
        }
    }
    else {
        die "Tom, fix this";
    }
}

sub auto-abbreviate(Str $string --> UInt) {
    # Given a string consisting of space-separated words, return the
    # minimum number of characters to abbreviate the set.  WARNING:
    # Inf is returned if there are duplicate words in the string, so
    # the user is warned to avoid that or catch the error exception.
    #
    # Source: http://rosettacode.org/wiki/Abbreviations,_automatic#Raku
    return Nil unless my @words = $string.words;
    return $_ if @words>>.substr(0, $_).Set == @words for 1 .. @words>>.chars.max;
    return Inf;
}
