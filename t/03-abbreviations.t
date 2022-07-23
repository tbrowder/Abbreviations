use Test;

use Abbreviations :ALL;

my $debug = 0;

##### subroutines #####
sub sort-len {$^a.chars cmp $^b.chars}

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
my @outL    = @outL-AL;
   @outL   .= append(<abcd abcde>);
   @outL   .= sort;
   @outL   .= sort(&sort-len);
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
    A     => 'A',
    Ab    => 'Abcde',
    Abc   => 'Abcde',
    Abcd  => 'Abcde',
    Abcde => 'Abcde',
    a     => 'ab',
    ab    => 'ab',
];
my @out-AL = <A a Ab>;
my @out    = @out-AL;
   @out   .= append(<Abc Abcd Abcde ab>);
   @out   .= sort;
   @out   .= sort(&sort-len);
my $out    = @out.join(' ');

plan 34;

# basic in/out
# 24 tests

# default, keep existing case
is-deeply abbreviations($in, :$debug), %out, "string in, hash out";
is-deeply abbreviations($in, :out-type(AH), :$debug), %out-AH, "string in, AbbrevHash out";
is-deeply abbreviations($in, :out-type(AL), :$debug), @out-AL, "string in, AbbrevList out";
is-deeply abbreviations($in, :out-type(L), :$debug), @out, "string in, List out";
is        abbreviations($in, :out-type(S), :$debug), $out, "string in, Str out";

is-deeply abbreviations(@in), %out, "list in, hash out";
is-deeply abbreviations(@in, :out-type(AH), :$debug), %out-AH, "list in, AbbrevHash out";
is-deeply abbreviations(@in, :out-type(AL), :$debug), @out-AL, "list in, AbbrevList out";
is-deeply abbreviations(@in, :out-type(L), :$debug), @out, "list in, List out";
is        abbreviations(@in, :out-type(S), :$debug), $out, "list in, Str out";

# test :lower-case option
is-deeply abbreviations($in, :lower-case, :$debug), %outL, "string in, hash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AH), :$debug), %outL-AH, "string in, AbbrevHash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AL), :$debug), @outL-AL, "string in, AbbrevList out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(L), :$debug), @outL, "string in, List out, lower-case";
is        abbreviations($in, :lower-case, :out-type(S), :$debug), $outL, "string in, Str out, lower-case";

is-deeply abbreviations(@in, :lower-case, :$debug), %outL, "list in, hash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AH), :$debug), %outL-AH, "list in, AbbrevHash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AL), :$debug), @outL-AL, "list in, AbbrevList out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(L), :$debug), @outL, "list in, List out, lower-case";
is        abbreviations(@in, :lower-case, :out-type(S), :$debug), $outL, "list in, Str out, lower-case";

# checking aliases
# 7 tests

is-deeply abbrevs(@in, :$debug), %out, "alias abbrevs";
is-deeply abbrev(@in, :$debug), %out, "alias abbrev";
is-deeply abbre(@in, :$debug), %out, "alias abbre";
is-deeply abbr(@in, :$debug), %out, "alias abbr";
is-deeply abb(@in, :$debug), %out, "alias abb";
is-deeply ab(@in, :$debug), %out, "alias ab";
is-deeply a(@in, :$debug), %out, "alias a";

# faulty and punctuation test data
# 5 tests

# leading or trailing space
my $bad-words1     = ' a ab abcde ';
my $bad-words1-out = 'a ab abc abcd abcde';
is abbreviations($bad-words1, :out-type(S), :$debug), $bad-words1-out, "string in with leading and trailing spaces";

# dup word
my $bad-words2 = 'a a ab abcde';
my $bad-words2-out = 'a ab abc abcd abcde';
is abbreviations($bad-words2, :out-type(S), :$debug), $bad-words2-out, "eliminate dup words";

# no word causes an exception
my $bad-words3a = '';
my $bad-words3b = ' ';
dies-ok {
    my $res = abbreviations($bad-words3a, :out-type(S), :$debug);
}, "FATAL: no words in ('')";
dies-ok {
    my $res = abbreviations($bad-words3b, :out-type(S), :$debug);
}, "FATAL: no words in (' ')";

# apostrophes, commas, periods, etc.
my @bad-words4 = <a,  a ' ; - * ! ? ab abcde>;
my $bad-words4-out = q{! ' * - ; ? a a, ab abc abcd abcde};
is abbreviations(@bad-words4, :out-type(S), :$debug), $bad-words4-out, "words and punctuation";

# other tests
my @w = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
my @dow = abbrevs @w, :lower-case, :out-type(AL), :$debug;
my $dow = abbrevs @w, :lower-case, :out-type(AL), :$debug;
my @d = <m tu w th f sa su>;
is-deeply @dow, @d, "AL test on days of the week";
is-deeply $dow, @d, "AL test on days of the week";

