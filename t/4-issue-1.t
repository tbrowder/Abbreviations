use Test;

use Abbreviations :ALL;

##### subroutines #####
sub sort-len {$^a.chars cmp $^b.chars} # now exported by the module as sort-list

# from issue #1
my $debug = 0;

# 2 tests
plan 3;

# this works:
my @list1 = <SAVE SEND SITE SOFT>;
my %exp1 = [
    SA   => "SAVE", 
    SAV  => "SAVE", 
    SAVE => "SAVE",  
    SE   => "SEND",  
    SEN  => "SEND",  
    SEND => "SEND",  
    SI   => "SITE",  
    SIT  => "SITE",  
    SITE => "SITE",  
    SO   => "SOFT",  
    SOF  => "SOFT",  
    SOFT => "SOFT", 
];

# this doesn't:
my @list2 = <SAVE SEND SITE SORT SORE>;
my @list3 = <SAVE SEND SITE SORE SORT>;
my %exp2 = [
    SA   => "SAVE", 
    SAV  => "SAVE", 
    SAVE => "SAVE", 
    SE   => "SEND", 
    SEN  => "SEND", 
    SEND => "SEND", 
    SI   => "SITE", 
    SIT  => "SITE", 
    SITE => "SITE", 
    SORE => "SORE", 
    SORT => "SORT",
];
my %exp3 = %exp2;

my %got1 = abbrevs @list1, :out-type(AH), :$debug;
my %got2 = abbrevs @list2, :out-type(AH), :$debug;
my %got3 = abbrevs @list3, :out-type(AH), :$debug;

is-deeply %got1, %exp1;
is-deeply %got2, %exp2;
is-deeply %got3, %exp3;
