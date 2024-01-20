use Test;

use Abbreviations :ALL;

use lib <./t/Utils>;
use Subs;

my $debug = 0;

plan 6;

# Single word
my $target = "Args";
my $junction = abbrevs $target;
is $junction, "A|Ar|Arg|Args", "Single word => /regex junction/";
my $regex = /{$junction}/;

my @args = $junction.split("|");
my $nfails;
my $nargs = @args.elems;

# subtest 1
subtest {
    plan 1;
    $nfails = test-regex(:$regex, :@args);
    is $nfails, 0, "expect 0 fails, got $nfails";
}, "subtest 1";

# subtest 2
subtest {
    plan 1;
    $target = "Args";
    $regex = /(A|Ar|Arg|Args)/;
    $nfails = test-regex(:$regex, :@args);
    is $nfails, 0, "expect 0 fails, got $nfails";
}, "subtest 2";

# subtest 3
subtest {
    plan 1;
    $target = "Args";
    @args = $junction.split("|");
    $regex = /^(A|Ar|Arg|Args)/;
    $nfails = test-regex(:$regex, :@args);
    is $nfails, 0, "Expected 0 fails, got $nfails";
}, "subtest 3";

# subtest 4
$target = "NArgs";
$junction = abbrev $target;
@args = $junction.split('|');
$nargs = @args.elems;
subtest {
    plan 1;
    $regex = /^(A|Ar|Arg|Args)/;
    $nfails = test-regex(:$regex, :@args);
    is $nfails, $nargs, "Expected $nargs fails, got $nfails";
}, "subtest 4";

# subtest 5
subtest {
    plan 1;
    $regex = /(A|Ar|Arg|Args)/;
    $nfails = test-regex(:$regex, :@args);
    is $nfails, 1, "Expected 1 fail, got $nfails";
}, "subtest 5";

