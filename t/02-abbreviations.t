use Test;

use Abbreviations :ALL;

my $debug = 0;

# good input test data
my @in = <A ab Abcde>;                    # arbitrary input order
my $in = @in.join(' ');                   # same as a string
my %in = 'A' => 0, 'ab'=> 1, 'Abcde'=> 2; # same, as a hash

# EXPECTED OUTPUT
# lower-case option
my %outL-HA = [
    # keyed by the input words, lower-cased, default out-type HA
    a     => 'a',
    ab    => 'ab',
    abcde => 'abc',
];
my %outL-H = [
    # keyed by the input words, lower-cased, out-type H
    a     => ['a'],
    ab    => ['ab'],
    abcde => ['abc', 'abcd', 'abcde'],
];
my %outL-AH = [
    # keyed by the valid abbreviations for the input words, lower-cased
    a     => 'a',
    ab    => 'ab',
    abc   => 'abcde',
    abcd  => 'abcde',
    abcde => 'abcde',
];
#my @in = <A ab Abcde>;
my @outL-AL = <a ab abc>;
my @outL    = @outL-AL;
   @outL   .= push('abcd');
   @outL   .= push('abcde');
   @outL    = sort-list @outL;
my $outL    = @outL.join(' ');

# default case-sensitive
my %out-HA = [
    # keyed by the input words and, optionally, $out-type HA
    A     => 'A',
    Abcde => 'Ab',
    ab    => 'a',
];
my %out-H = [
    # keyed by the input words and $out-type H
    # (this was the original default)
    A     => ['A'],
    Abcde => ['Ab', 'Abc', 'Abcd', 'Abcde'],
    ab    => ['a', 'ab'],
];
my %out-AH = [
    # keyed by the valid abbreviations for the input words
    A     => 'A',
    Ab    => 'Abcde',
    Abc   => 'Abcde',
    Abcd  => 'Abcde',
    Abcde => 'Abcde',
    a     => 'ab',
    ab    => 'ab',
];
#my @in = <A ab Abcde>;
#my @outL-AL = <a ab abc>;
my @out-AL = <A a Ab>;
my @out    = @out-AL;
   @out   .= append: <Abc Abcd Abcde ab>;
   @out    = sort-list @out;
my $out    = @out.join(' ');

plan 42;

# basic in/out
# 42 tests

# default, keep existing case
is-deeply abbreviations($in, :$debug), %out-HA, "string in, default hash HA out";
is-deeply abbreviations($in, :out-type(HA), :$debug), %out-HA, "string in, hash HA (default)";
is-deeply abbreviations($in, :out-type(H),  :$debug), %out-H,  "string in, hash H (old default)";
is-deeply abbreviations($in, :out-type(AH), :$debug), %out-AH, "string in, AbbrevHash out";
is-deeply abbreviations($in, :out-type(AL), :$debug), @out-AL, "string in, AbbrevList out";
is-deeply abbreviations($in, :out-type(L),  :$debug), @out,    "string in, List out";
is        abbreviations($in, :out-type(S),  :$debug), $out,    "string in, Str out";

is-deeply abbreviations(@in, :$debug), %out-HA, "list in, default hash HA out";
is-deeply abbreviations(@in, :out-type(HA), :$debug), %out-HA, "list in, default hash HA out";
is-deeply abbreviations(@in, :out-type(H),  :$debug), %out-H,  "list in, hash H out";
is-deeply abbreviations(@in, :out-type(AH), :$debug), %out-AH, "list in, AbbrevHash out";
is-deeply abbreviations(@in, :out-type(AL), :$debug), @out-AL, "list in, AbbrevList out";
is-deeply abbreviations(@in, :out-type(L),  :$debug), @out,    "list in, List out";
is        abbreviations(@in, :out-type(S),  :$debug), $out,    "list in, Str out";

is-deeply abbreviations(%in, :$debug), %out-HA, "hash in, default hash HA out";
is-deeply abbreviations(%in, :out-type(HA), :$debug), %out-HA, "hash in, default hash HA out";
is-deeply abbreviations(%in, :out-type(H),  :$debug), %out-H,  "hash in, hash H out";
is-deeply abbreviations(%in, :out-type(AH), :$debug), %out-AH, "hash in, AbbrevHash out";
is-deeply abbreviations(%in, :out-type(AL), :$debug), @out-AL, "hash in, AbbrevList out";
is-deeply abbreviations(%in, :out-type(L),  :$debug), @out,    "hash in, List out";
is        abbreviations(%in, :out-type(S),  :$debug), $out,    "hash in, Str out";

# test :lower-case option
is-deeply abbreviations($in, :lower-case, :$debug), %outL-HA, "string in, default hash HA out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(HA), :$debug), %outL-HA, "string in, hash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(H),  :$debug), %outL-H,  "string in, hash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AH), :$debug), %outL-AH, "string in, AbbrevHash out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(AL), :$debug), @outL-AL, "string in, AbbrevList out, lower-case";
is-deeply abbreviations($in, :lower-case, :out-type(L),  :$debug), @outL,    "string in, List out, lower-case";
is        abbreviations($in, :lower-case, :out-type(S),  :$debug), $outL,    "string in, Str out, lower-case";

is-deeply abbreviations(@in, :lower-case, :$debug), %outL-HA, "list in, default hash HA out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(HA), :$debug), %outL-HA, "list in, hash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(H),  :$debug), %outL-H,  "list in, hash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AH), :$debug), %outL-AH, "list in, AbbrevHash out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(AL), :$debug), @outL-AL, "list in, AbbrevList out, lower-case";
is-deeply abbreviations(@in, :lower-case, :out-type(L),  :$debug), @outL,    "list in, List out, lower-case";
is        abbreviations(@in, :lower-case, :out-type(S),  :$debug), $outL,    "list in, Str out, lower-case";

is-deeply abbreviations(%in, :lower-case, :$debug), %outL-HA, "hash in, default hash HA out, lower-case";
is-deeply abbreviations(%in, :lower-case, :out-type(HA), :$debug), %outL-HA, "hash in, hash out, lower-case";
is-deeply abbreviations(%in, :lower-case, :out-type(H),  :$debug), %outL-H,  "hash in, hash out, lower-case";
is-deeply abbreviations(%in, :lower-case, :out-type(AH), :$debug), %outL-AH, "hash in, AbbrevHash out, lower-case";
is-deeply abbreviations(%in, :lower-case, :out-type(AL), :$debug), @outL-AL, "hash in, AbbrevList out, lower-case";
is-deeply abbreviations(%in, :lower-case, :out-type(L),  :$debug), @outL,    "hash in, List out, lower-case";
is        abbreviations(%in, :lower-case, :out-type(S),  :$debug), $outL,    "hash in, Str out, lower-case";
