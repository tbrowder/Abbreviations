unit module Abbreviations:ver<0.3.3>:auth<cpan:TBROWDER>;

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

There are two shorter routine name abbreviations one can use that are
always exported:

=begin code :lang<raku>
 abbrevs
 abbrev
=end code

In the sprit of the module, one can C<use Abbreviations :ALL;> and
have these additional short forms available:

=begin code :lang<raku>
 abbre
 abbr
 abb
 ab
 a
=end code

Each of those is individually available by adding its name as an
adverb, e.g.:

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
with the words as keys. Duplicate words will be automatically and
quietly eliminated (at some slight extra processing cost), but you can
use the ':warn' option if you want to be notified. An empty input word
set will throw an exception.


One will normally get the result as a C<Hash>, but the return type can
be specified if desired by selecting either option C<:Str> or option
C<:List> (the C<:List> takes precedence silently if both are selected):

=begin code
my $abbrevs = abbrevs $words, :Str;
my @abbrevs = abbrevs $words, :List;
=end code

Note the results as C<Str> or C<List> will contain the original words
as well as any other valid abbreviated form. The C<Hash> returned will
have input words as keys whose value will be either empty strings for
those keys without a shorter abbreviation or a string of one or more
valid but shorter abbreviations for others.

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

The default hash returned will show the abbreviations attached
as a string to the parent word. That result for the previous input
example is

    a     => '',
    ab    => '',
    abcde => 'abc abcd'

=head1 AUTHOR

Tom Browder <tbrowder@cpan.org>

=head1 CREDITS

=item Leon Timmermans (aka @Leont) for inspiration from his Raku module C<Getopt::Long>.

=item @Thundergnat, the original author of the Raku C<auto-abbreviate> algorithm on L<Rosetta Code|http://rosettacode.org/wiki/Abbreviations,_automatic#Raku>.

=item The Raku community for help with subroutine signatures.

=head1 COPYRIGHT and LICENSE

Copyright &#x00A9; 2020 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

=end pod

sub check-dups($words where Str|List, :$warn --> Str) {
    # The input is either a Str or a List.  The return is a sorted
    # string for input into auto-abbreviation.

    my @w;
    given $words {
        when Str {
            @w = $_.words;
            die "FATAL: Empty input word set." if !@w.elems;
        }
        when List {
            @w = $_;
            die "FATAL: Empty input word set." if !@w.elems;
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

    if @dups.elems and $warn {
        my $s = @dups.sort.join: ' ';
        note "\nWARNING: Found the following duplicate words: '$s'";
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
                  # Make the return type be either
                  # Str or List instead of the default Hash.
                  # List takes precedence if both are true.
                  :$Str  = 0,
                  :$List = 0,
                 ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word.

    my Str $abbrev-str;
    my $in-typ;
    if $word-set ~~ Str {
        $abbrev-str = $word-set;
        $in-typ = 'Str';
    }
    elsif $word-set ~~ List {
        $abbrev-str = $word-set.sort.join(' ');
        $in-typ = 'List';
    }
    elsif $word-set ~~ Hash {
        $abbrev-str = $word-set.keys.sort.join(' ');
        $in-typ = 'Hash';
    }
    else {
        die "FATAL: Cannot handle word set format '{$word-set.^name}'";
    }

    if $abbrev-str !~~ /\S/ {
        die "FATAL: Empty input word set.";
    }
    $abbrev-str = check-dups $abbrev-str, :$warn;

    # Determine output type if not default Hash.  List takes
    # precedence.
    my $out-typ = $List ?? 'List'
                        !! $Str ?? 'Str' !! 'Hash';

    # A returned Hash has the input words as keys whose values are 
    # space-separated strings of their unique shorter abbreviations, if
    # any.

    # At this point we should have:
    #   + thrown an exception for an empty input word set.
    #   + removed dups from the input word set.

    # Get the max number of characters needed to have a unique
    # abbreviation.  If the number of characters in a word is equal or
    # less, then it has no abbreviation.

    my $max-chars = auto-abbreviate $abbrev-str;

    # Prepare the desired output
    my %ow;
    my @ow;
    my $ow = '';
    for $abbrev-str.words.sort -> $w {
        %ow{$w} = '';
        my $nc = $w.chars;
        if $nc <= $max-chars {
            # no abbreviation
            if $out-typ eq 'Str' {
                $ow ~= ' ' if $ow;
                $ow ~= $w;
            }
            elsif $out-typ eq 'List' {
                @ow.push: $w;
            }
            next;
        }

        # Handle the abbreviations
        my $len = $max-chars;
        while $len <= $nc {
            my $a = $w.substr(0, $len);
            if $out-typ eq 'Str' {
                $ow ~= ' ' if $ow;
                $ow ~= $a;
            }
            elsif $out-typ eq 'List' {
                @ow.push: $a;
            }
            # Hashes need extra attention because the key (the primary
            # word) is already in the output set:
            elsif $out-typ eq 'Hash' and $len < $nc {
                %ow{$w} ~= ' ' if %ow{$w};
                %ow{$w} ~= $a;
            }
            ++$len;
        }
    }

    if $out-typ eq 'Hash' {
        return %ow;
    }
    elsif $out-typ eq 'Str' {
        return $ow;
    }
    elsif $out-typ eq 'List' {
        return @ow;
    }
    else {
        die "FATAL: Unexpected \$out-typ '$out-typ'";
    }
}

sub auto-abbreviate(Str $string) is export(:auto) {
    # Given a string consisting of space-separated words, return the
    # minimum number of characters to abbreviate the set.  WARNING:
    # Inf is returned if there are duplicate words in the string, so
    # the user is warned to avoid that or catch the error exception.
    #
    # Source: http://rosettacode.org/wiki/Abbreviations,_automatic#Raku

    return Nil unless my @words = $string.words; # The caller should of taken care of that.

    # The normal situation:
    return $_ if @words>>.substr(0, $_).Set == @words for 1 .. @words>>.chars.max;

    # There are duplicate words in the input word set.
    # NOTE: Our caller should have taken care of that.
    return Inf;
}
