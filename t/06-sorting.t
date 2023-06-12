use Test;

use Abbreviations :ALL;

my $debug = 0;

#reverse
#by enum 

# input test data
my @in = <Bc a B>;                    
# expected
my @outLS     = <B a Bc>;                    
my @outLS-rev = <Bc a B>;
my @outSL     = <B Bc a>;                    
my @outSL-rev = <a Bc B>;                    

is sort-list(@in), @outLS, "default, LS";
is sort-list(@in, :reverse), @outLS-rev, "default, LS, reversed";

is sort-list(@in, :type(LS)), @outLS, "type LS";
is sort-list(@in, :type(LS), :reverse), @outLS-rev, "type LS, reversed";

is sort-list(@in, :type(SL)), @outSL, "type SL";
is sort-list(@in, :type(SL), :reverse), @outSL-rev, "type SL, reversed";

done-testing;


