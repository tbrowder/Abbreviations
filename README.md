[![Actions Status](https://github.com/tbrowder/Abbreviations/workflows/test/badge.svg)](https://github.com/tbrowder/Abbreviations/actions)

NAME
====

Abbreviations - provides abbreviations for an input set of one or more words

SYNOPSIS
========

```raku
use Abbreviations;
my $words = 'a ab abcde';
# The main exported routine:
my %abbrevs = abbreviations $words;
```

There are two shorter routine name abbreviations one can use that are always exported:

```raku
 abbrevs
 abbrev
```

In the sprit of the module, one can `use Abbreviations :ALL;` and have these additional short forms available:

```raku
 abbre
 abbr
 abb
 ab
 a
```

Each of those is individually available by adding its name as an adverb, e.g.:

```raku
use Abbreviations :abb;
my %abb = abb $words;
```

DESCRIPTION
===========

**Abbreviations** is a module with one exported multi subroutine, `abbreviations`, which takes as input a set of words and returns the original set with added unique abbreviations for the set. (Note the input words are also abbreviations in the context of this module.)

A **word** satisfies the Raku regex: `$word ~~ /\S+/` which is quite loose. Using programs can of course further restrict that if need be. For example, for use with module **Opt::Handler** words must satisfy this regex: `$word ~~ /<ident>/`.

The input word set can be in one of three forms: (1) a string containing the words separated by spaces, (2) a list, or (3) a hash with the words as keys. Duplicate words will be automatically and quietly eliminated (at some slight extra processing cost), but you can use the ':warn' option if you want to be notified. An empty input word set will throw an exception.

One will normally get the result as a `Hash`, but the return type can be specified if desired by selecting either option `:Str` or option `:List` (the `:List` takes precedence silently if both are selected):

    my $abbrevs = abbrevs $words, :Str;
    my @abbrevs = abbrevs $words, :List;

Note the results as `Str` or `List` will contain the original words as well as any other valid abbreviated form. The `Hash` returned will have input words as keys whose value will be either empty strings for those keys without a shorter abbreviation or a string of one or more valid but shorter abbreviations for others.

For example, given an input set consisting of the words

    a
    ab
    abcde

the list of abbreviations (which incudes the original words) is

        a
        ab
        abc    # <== abbreviation for abcde
        abcd   # <== abbreviation for abcde
        abcde

The default hash returned will show the abbreviations attached as a string to the parent word. That result for the previous input example is

    a     => '',
    ab    => '',
    abcde => 'abc abcd'

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

CREDITS
=======

  * Leon Timmermans (aka @Leont) for inspiration from his Raku module `Getopt::Long`.

  * @Thundergnat, the original author of the Raku `auto-abbreviate` algorithm on [Rosetta Code](http://rosettacode.org/wiki/Abbreviations,_automatic#Raku).

  * The Raku community for help with subroutine signatures.

COPYRIGHT and LICENSE
=====================

Copyright &#x00A9; 2020 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

