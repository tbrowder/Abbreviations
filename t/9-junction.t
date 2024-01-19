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
my ($ntests, $nfails);
my $nargs = @args.elems;

# subtest 1
subtest {
    ($ntests, $nfails) = test-junction(:$regex, :$target, :@args);
    is $ntests, $nargs, "ntests $ntests";
    is $nfails, 0, "expect 0 fails, got $nfails";
}, "subtest 1";

# subtest 2
subtest {
    $target = "Args";
    $junction = /(A|Ar|Arg|Args)/;
    ($ntests, $nfails) = test-junction(:$regex, :$junction, :$target, :@args);
    is $ntests, $nargs, "ntests $ntests";
    is $nfails, 0, "expect 0 fails, got $nfails";
}, "subtest 2";

# subtest 3
subtest {
    $target = "Args";
    $junction = /^(A|Ar|Arg|Args)/;
    ($ntests, $nfails) = test-junction(:$regex, :$target, :@args);
    is $ntests, $nargs, "ntests $ntests";
    is $nfails, 0, "Expected 0 fails, got $nfails";
}, "subtest 3";

# subtest 4
subtest {
    $target = "NArgs";
    $junction = /^(A|Ar|Arg|Args)/;
    ($ntests, $nfails) = test-junction(:$regex, :$target, :@args);
    is $ntests, $nargs, "ntests $ntests";
    is $nfails, $nargs, "Expected $nargs fails, got $nfails";
}, "subtest 4";

# subtest 5
subtest {
    $target = "NArgs";
    $junction = /(A|Ar|Arg|Args)/;
    ($ntests, $nfails) = test-junction(:$regex, :$target, :@args);
    is $ntests, $nargs, "ntests $ntests";
    is $nfails, 0, "Expected 0 fails, got $nfails";
}, "subtest 5";

done-testing;
