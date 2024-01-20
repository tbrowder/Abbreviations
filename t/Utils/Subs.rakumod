unit module Subs;

use Abbreviations :ALL;

# We create a $regex from the abbreviation of the arg .
# We split that to form the @args input list.

sub test-regex(
    :@args!,
    :$regex!,
    :$debug,
    --> UInt
) is export {
    my $nfails = 0;
    my $res;
    for @args { 
        when $_ ~~ $regex { 
            $res = True  
        }
        default { 
            $res = False; 
            ++$nfails 
        }
    }
    $nfails
}
