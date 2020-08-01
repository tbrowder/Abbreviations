use Test;

use Abbreviations;

#plan 1;

# good input test data
# EXPECTED
my $in-words = 'a ab abcde';
my @in-words = $in-words.words;
my %in-words = set @in-words;

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

# send list, get string
# check options

# send list, get hash


# place holder for now
is "e", "e";

done-testing;


