unit module Subs;

use Abbreviations :ALL;

sub test-regex(
    :$target!,
    :@args!,
    :$regex!,
    :$debug,
    --> List
) is export {
    my $ntests = 0;
    my $nfails = 0;
    my $res;
    for @args { 
        ++$ntests; 
        when $_ ~~ $regex { 
            $res = True  
        }
        default { 
            $res = False; 
            ++$nfails 
        }
    }
    $ntests, $nfails
}
