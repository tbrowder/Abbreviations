use Test;

use Abbreviations :ALL;

my $debug = 0;

plan 1;

# good input test data
my %in = set <A ab Abcde>;                     # set input order
my %out = [
    # keyed by the input words and, optionally, $out-type HA
    A     => 'A',
    Abcde => 'Ab',
    ab    => 'a',
];

is-deeply abbreviations(%in, :$debug), %out, "input set of words";
