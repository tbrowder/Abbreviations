use Test;

use Abbreviations :ALL;

# good input test data
my @in = <A ab Abcde>;
my $in = @in.join(' ');

# EXPECTED
# lower-case option: min abbrev 3
my %outL = [
    # keyed by the input words, lower-cased
    a     => ['a'],
    ab    => ['ab'],
    abcde => ['abc', 'abcd', 'abcde'],
];
my %outL-AH = [
    # keyed by the valid abbreviations for the input words, lower-cased
    a     => 'a',
    ab    => 'ab',
    abc   => 'abcde',
    abcd  => 'abcde',
    abcde => 'abcde',
];
my @outL-AL = <a ab abc>;
my @outL    = @outL-AL.append(<abcd abcde>);
my $outL    = @outL.join(' ');


# default case-sensitive
my %out = [
    # keyed by the input words
    A     => ['A'],
    Abcde => ['Ab', 'Abc', 'Abcd', 'Abcde'],
    ab    => ['a', 'ab'],
];
my %out-AH = [
    # keyed by the valid abbreviations for the input words
    A => 'A',
    Ab    => 'Abcde',
    Abc   => 'Abcde',
    Abcd  => 'Abcde',
    Abcde => 'Abcde',
    a     => 'ab',
    ab    => 'ab',
];
my @out-AL = <A ab Ab>;
my @out    = @out-AL.append(<Abcd Abcde>);
my $out    = @out.join(' ');

plan 27;

# basic in/out
# 24 tests

# default, keep existing case
is-deeply abbreviations($in), %out, "string in, hash out";
is-deeply abbreviations($in, :out-type(AH)), %out-AH, "string in, AbbrevHash out";
is-deeply abbreviations($in, :out-type(AL)), @out-AL, "string in, AbbrevList out";
is-deeply abbreviations($in, :out-type(L)), @out, "string in, List out";
is        abbreviations($in, :out-type(S)), $out, "string in, Str out";

is-deeply abbreviations(@in), %out, "list in, hash out";
is-deeply abbreviations(@in, :out-type(AH)), %out-AH, "list in, AbbrevHash out";
is-deeply abbreviations(@in, :out-type(AL)), @out-AL, "list in, AbbrevList out";
is-deeply abbreviations(@in, :out-type(L)), @out, "list in, List out";
is        abbreviations(@in, :out-type(S)), $out, "list in, Str out";

# test :lower-case option
is-deeply abbreviations($in, :lower-case), %outL, "string in, hash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AH)), %outL-AH, "string in, AbbrevHash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AL)), @outL-AL, "string in, AbbrevList out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(L)), @outL, "string in, List out, lower-case";
is        abbreviations($in, :lower-case, :out-type(S)), $outL, "string in, Str out, lower-case";

is-deeply abbreviations(@in, :lower-case), %outL, "list in, hash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AH)), %outL-AH, "list in, AbbrevHash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AL)), @outL-AL, "list in, AbbrevList out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(L)), @outL, "list in, List out, lower-case";
is        abbreviations(@in, :lower-case, :out-type(S)), $outL, "list in, Str out, lower-case";


# checking aliases
# 7 tests

is-deeply abbrevs(@in), %out, "alias abbrevs";
is-deeply abbrev(@in), %out, "alias abbrev";
is-deeply abbre(@in), %out, "alias abbre";
is-deeply abbr(@in), %out, "alias abbr";
is-deeply abb(@in), %out, "alias abb";
is-deeply ab(@in), %out, "alias ab";
is-deeply a(@in), %out, "alias a";

=begin comment
# faulty and punctuation test data
# 5 tests

# leading or trailing space
my $bad-words1     = ' a ab abcde ';
my $bad-words1-out = 'a ab abcd abcde';
is abbreviations($bad-words1, :Str), $bad-words1-out, "string in with leading and trailing spaces";

# dup word
my $bad-words2 = 'a a ab abcde';
my $bad-words2-out = 'a ab abcd abcde';
is abbreviations($bad-words2, :Str), $bad-words2-out, "eliminate dup words";

# no word causes an exception
my $bad-words3a = '';
my $bad-words3b = ' ';
dies-ok {
    my $res = abbreviations($bad-words3a, :Str);
}, "FATAL: no words in ('')";
dies-ok {
    my $res = abbreviations($bad-words3b, :Str);
}, "FATAL: no words in (' ')";

# apostrophes, commas, periods, etc.
my @bad-words4 = <a,  a ' ; - * ! ? ab abcde>;
my $bad-words4-out = q{! ' * - ; ? a a, ab abcd abcde};
is abbreviations($bad-words4, :Str), $bad-words4-out, "words and punctuation";
=end comment

##### subroutines #####
sub sort-len {$^a.chars cmp $^b.chars}
