use Test;

my $debug = 0;

plan 3;

use Abbreviations :ALL;
my $words = 'A ab Abcde';
# The main exported routine:
my %abbrevs = abbreviations $words;
is %abbrevs<A>, 'A';
is %abbrevs<ab>, 'a';
is %abbrevs<Abcde>, 'Ab';
