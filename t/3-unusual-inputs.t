use Test;

use Abbreviations :ALL;

my $debug = 0;

plan 20;

# good input test data
my @in = <A ab Abcde>;                     # arbitrary input order
my %out = [
    # keyed by the input words and, optionally, $out-type HA
    A     => 'A',
    Abcde => 'Ab',
    ab    => 'a',
];

# checking aliases
# 7 tests

is-deeply abbrevs(@in, :$debug), %out, "alias abbrevs";
is-deeply abbrev(@in, :$debug), %out, "alias abbrev";
is-deeply abbre(@in, :$debug), %out, "alias abbre";
is-deeply abbr(@in, :$debug), %out, "alias abbr";
is-deeply abb(@in, :$debug), %out, "alias abb";
is-deeply ab(@in, :$debug), %out, "alias ab";
is-deeply a(@in, :$debug), %out, "alias a";

# faulty and punctuation test data
# 5 tests

# leading or trailing space
my $bad-words1     = ' a ab abcde ';
my $bad-words1-out = 'a ab abc abcd abcde';
is abbreviations($bad-words1, :out-type(S), :$debug), $bad-words1-out, "string in with leading and trailing spaces";

# dup word
my $bad-words2 = 'a a ab abcde';
my $bad-words2-out = 'a ab abc abcd abcde';
is abbreviations($bad-words2, :out-type(S), :$debug), $bad-words2-out, "eliminate dup words";

# no word causes an exception
my $bad-words3a = '';
my $bad-words3b = ' ';
dies-ok {
    my $res = abbreviations($bad-words3a, :out-type(S), :$debug);
}, "FATAL: no words in ('')";
dies-ok {
    my $res = abbreviations($bad-words3b, :out-type(S), :$debug);
}, "FATAL: no words in (' ')";

# apostrophes, commas, periods, etc.
my @bad-words4 = <a,  a ' ; - * ! ? ab abcde>;
my $bad-words4-out = q{! ' * - ; ? a a, ab abc abcd abcde};
is abbreviations(@bad-words4, :out-type(S), :$debug), $bad-words4-out, "words and punctuation";

# other tests
my @w = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
my @d = <m tu w th f sa su>;
#my @dow = abbrevs @w, :lower-case, :out-type(AL), :$debug;
my @dow = abbreviations @w, :lower-case, :out-type(AL), :$debug;
is @dow, @d, "AL test on days of the week";

my $dow = abbrevs @w, :lower-case, :out-type(AL), :$debug;
is @dow, @d, "AL test on days of the week";

is-deeply $dow, @d, "AL test on days of the week";

# Single word
@w = <Args>;
$dow = abbrevs @w;
is $dow, "A|Ar|Arg|Args", "Single word => /regex junction/";

# input tests
@w = <A Ar Arg Args>;
my $res = False;
for @w {
    when /(A|Ar|Arg|Args)/ {
        $res = True
    }
    default {
        $res = False
    }
}
is $res, True;

my $junction = 'A|Ar|Arg|Args';
$res = False;
for @w {
    when /<$junction>/ {
        $res = True
    }
    default {
        $res = False
    }
}
is $res, True;

$junction = "A|Ar|Arg|Args|N";
$res = False;
for @w {
    when /^<$junction>/ {
        $res = True
    }
    default {
        $res = False
    }
}
is $res, False;

subtest {
    # example in README
    my $target = "Args";
    my $junction = abbrev $target; # OUTPUT: "A|Ar|Arg|Args";
    my $res = False;
    for @w { #$junction.split(/'|'/) {
        when /<$junction>/ { $res = True  }
        default          { $res = False }
    }
    is $res, True, "README example"; # OUTPUT: ok 1
}
