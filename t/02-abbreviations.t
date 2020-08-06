use Test;

use Abbreviations :ALL;

# good input test data
# EXPECTED
my $in-words  = 'a ab abcde';
my $out-words = 'a ab abc abcd abcde';

my @in-words = $in-words.words;
my @out-words = <a ab abc abcd abcde>;
my %in-words = set @in-words;
my %out-words = %(
    a     => '',
    ab    => '',
    abcde => 'abc abcd'
);

plan 25;

# basic in/out
# 12 tests

is-deeply abbreviations($in-words), %out-words, "string in, hash out";
is        abbreviations($in-words, :Str), $out-words, "string in, string out";
is-deeply abbreviations($in-words, :List), @out-words, "string in, list out";
is-deeply abbreviations($in-words, :Str, :List), @out-words, "string in, list out with precedence";

is-deeply abbreviations(@in-words), %out-words, "list in, hash out";
is        abbreviations(@in-words, :Str), $out-words, "list in, string out";
is-deeply abbreviations(@in-words, :List), @out-words, "list in, list out";
is-deeply abbreviations(@in-words, :Str, :List), @out-words, "list in, list out with precedence";

is-deeply abbreviations(%in-words), %out-words, "hash in, hash out";
is        abbreviations(%in-words, :Str), $out-words, "hash in, string out";
is-deeply abbreviations(%in-words, :List), @out-words, "hash in, list out";
is-deeply abbreviations(%in-words, :Str, :List), @out-words, "hash in, list out with precedence";

# checking aliases
# 7 tests

is-deeply abbrevs(%in-words), %out-words, "alias abbrevs";
is-deeply abbrev(%in-words), %out-words, "alias abbrev";
is-deeply abbre(%in-words), %out-words, "alias abbre";
is-deeply abbr(%in-words), %out-words, "alias abbr";
is-deeply abb(%in-words), %out-words, "alias abb";
is-deeply ab(%in-words), %out-words, "alias ab";
is-deeply a(%in-words), %out-words, "alias a";

# faulty and punctuation test data
# 6 tests

# leading or trailing space
my $bad-words1     = ' a ab abcde ';
my $bad-words1-out = 'a ab abc abcd abcde';
is abbreviations($bad-words1, :Str), $bad-words1-out, "string in with leading and trailing spaces";

# dup word
my $bad-words2 = 'a a ab abcde';
my $bad-words2-out = 'a ab abc abcd abcde';
is abbreviations($bad-words2, :Str), $bad-words2-out, "dup words without :warn";
is abbreviations($bad-words2, :Str, :warn), $bad-words2-out, "dup words with :warn";

# no word
my $bad-words3a = '';
my $bad-words3b = '';
my $bad-words3-out = '';
is abbreviations($bad-words3a, :Str), $bad-words3-out, "no words in ('')";
is abbreviations($bad-words3b, :Str), $bad-words3-out, "no words in (' ')";

# apostrophes, commas, periods, etc.
my $bad-words4 = q{a,  a ' ; - * ! ? ab abcde};
my $bad-words4-out = q{! ' * - ; ? a a, ab abc abcd abcde};
is abbreviations($bad-words4, :Str), $bad-words4-out, "words and punctuation";
