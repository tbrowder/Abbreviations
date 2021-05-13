use Test;

use Abbreviations :ALL;

plan 2;

# EXPECTED
#== case-insensitive:
my $in-words    = 'a ab abcde';
my @in-words    = $in-words.words.sort;
my $min-abbrev  = 3;
#== case-sensitive:
my $in-words2   = 'A ab Abcde';
my @in-words2   = $in-words2.words.sort;
my $min-abbrev2 = 2;

my $na  = auto-abbreviate @in-words;
my $na2 = auto-abbreviate @in-words2;

is $na, $min-abbrev, "lower-case, word: '$in-words', min-abbrev: $na";
is $na2, $min-abbrev2, "mixed-case, word: '$in-words2', min-abbrev: $na2";

