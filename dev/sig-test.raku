#!/usr/bin/env raku

#enum Out-type (S => 'Str', L => 'List', AH => 'AbbrevHash', AL => 'AbbrevList', H => 'Hash');
use lib <../lib>;
use Abbreviations;

say Out-type.kv;
say S;
say S.value;

t :otyp(S);
t();
t :otyp(H);
t :otyp(L);
t :otyp(AL);

sub t(Out-type :$otyp where {S|L|H|AL|AH} = H) is export {
    say "out-type = $otyp";
    say "out-type value = {$otyp.value}";
    #if $otyp ~~ Str {
    if $otyp ~~ /Str/ {
        say "smart match: out-type value = {$otyp.value}";
    }
    elsif $otyp ~~ /L/ {
        say "smart match: out-type value = {$otyp.value}";
    }
}



=finish

use lib <../lib>;
use Abbreviations :ALL;

# good input test data
my @in = <A ab Abcde>;
my $in = @in.join(' ');

my @inL = $in.lc.words;
my $inL = $in.lc;

my ($res, @res, %ow);

say "Input words: '$in'";

# default, keep existing case
%ow = abbreviations($in);
say "\n=== Output hash:";
say %ow;
say "\n=== Output hash inverted:";
my @inv = %ow.invert;
my %inv;
for @inv -> $p {
    #say $p.raku;
    #say "pair: {$p.key} => {$p.value}";
    %inv{$p.key} = $p.value;
}
say %inv;

say "\n=== Output hash converted to min abbrev hash:";
my %mh;
for %ow.kv -> $w, $v {
    my $m = @($v)[0];
    say "word: $w => min abbrev: $m";
    %mh{$w} = $m;
}

#================================================
say "\n=== Output hash converted to AbbrevHash:";
my %ah;
for %ow.kv -> $w, $v {
    my $m = @($v)[0];
    say "min abbrev: $m => word: $w";
    %ah{$m} = $w;
}
say "\n=== Output hash converted to AbbrevList:";
my @al;
for @in -> $w {
    # for each word, add its min abbrev to the list
    my $m = %mh{$w};
    @al.push: $m;
}
say "in words: {@in}";
say " abbrevs: {@al}";
#================================================

=finish

#%ow = abbreviations($in, :AbbrevHash);
#say %ow;

#@res = abbreviations($in, :AbbrevList);
#say @res;

@res = abbreviations($in, :List);
say "\n=== Output list:";
say @res;

$res = abbreviations($in, :Str);
say "\n=== Output string:";
say $res;

# test :lower-case option
%ow = abbreviations($in, :lower-case);
say "\n=== Output lower-case hash:";
say %ow;

#%ow = abbreviations($in, :lower-case, :AbbrevHash);
#say %ow;

#@res = abbreviations($in, :lower-case, :AbbrevList);
#say @res;

@res = abbreviations($in, :lower-case, :List);
say "\n=== Output lower-case list:";
say @res;

$res = abbreviations($in, :lower-case, :Str);
say "\n=== Output lower-case string:";
say $res;
