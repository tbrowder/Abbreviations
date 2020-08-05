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

plan 10;

is-deeply abbreviations($in-words), $out-words;
is-deeply abbreviations(@in-words), @out-words;
is-deeply abbreviations(%in-words), %out-words;
is-deeply abbrevs(%in-words), %out-words;
is-deeply abbrev(%in-words), %out-words;
is-deeply abbre(%in-words), %out-words;
is-deeply abbr(%in-words), %out-words;
is-deeply abb(%in-words), %out-words;
is-deeply ab(%in-words), %out-words;
is-deeply a(%in-words), %out-words;

# faulty test data
# leading or trailing space
my $bad-words1 = ' a ab abcde ';
# dup word
my $bad-words2 = 'a a ab abcde';
# no word
my $bad-words3 = '';
# apostrophes, commas, periods, etc.
my $bad-words4 = <a,  a ' ; - * ! ? ab abcde>;

=begin comment

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

=end comment

# three input types

#= STRING INPUT
# send string, get string
#   check options

# send string, get list
#   check options

# send string, get hash
#   check options

#= LIST INPUT
# send list, get string
#   check options

# send list, get list
#   check options

# send list, get hash
#   check options

#= HASH INPUT
# send hash, get string
#   check options

# send hash, get list
#   check options

# send hash, get hash
#   check options
