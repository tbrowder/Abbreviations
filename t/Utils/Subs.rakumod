unit module Subs;

use Abbreviations :ALL;

sub test-junction(
    :$target!,
    :@args!,
    :$junction is copy,
    :$debug,
) is export {
    unless $junction {
        $junction = abbrev $target;
    }

    my $nfails = 0;
    my $res;
    for @args { 
        when /<$junction>/ { 
            $res = True  
        }
        default { 
            $res = False; 
            ++$nfails 
        }
    }
    $nfails
}
