use Test;

use Abbreviations :ALL;

use lib <./t/Utils>;
use Subs;

my $debug = 0;

#plan 20;

# Single word
my $target = "Args";
my $junction = abbrevs $target;
is $junction, "A|Ar|Arg|Args", "Single word => /regex junction/";

my @args = $junction.split("|");
is test-junction(:$target, :@args), 0;

$junction = "^(A|Ar|Arg|Args)";
is test-junction(:$junction, :$target, :@args), 0;

$target = "NArgs";
is test-junction(:$junction, :$target, :@args), 4;

$junction = "A|Ar|Arg|Args";
is test-junction(:$junction, :$target, :@args), 0;

done-testing;
