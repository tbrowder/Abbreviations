use Test;

use Abbreviations :ALL;

my $debug = 0;

plan 3;

# min-length tests
my @w  = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
my @d  = <m tu w th f sa su>;
my @d2 = <mo tu we th fr sa su>;
my @d3 = <mon tue wed thu fri sat sun>;

my @dow  = abbreviations @w, :lower-case, :out-type(AL), :$debug;
my @dow2 = abbreviations @w, :lower-case, :min-length(2), :out-type(AL), :$debug;
my @dow3 = abbreviations @w, :lower-case, :min-length(3), :out-type(AL), :$debug;

is @dow, @d, "AL test on days of the week";
is @dow2, @d2, "AL test on days of the week, min-length 2";
is @dow3, @d3, "AL test on days of the week, min-length 3";
