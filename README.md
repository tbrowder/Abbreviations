[![Actions Status](https://github.com/tbrowder/Abbreviations/workflows/test/badge.svg)](https://github.com/tbrowder/Abbreviations/actions)

NAME
====

Abbreviations - Provides abbreviations for an input set of one or more words

SYNOPSIS
========

```raku
use Abbreviations;
my $words = 'A ab Abcde';
# The main exported routine:
my %abbrevs = abbreviations $words;
# OUTPUT:
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

**Abbreviations** is a module with one automaticall exported multi-subroutine, `abbreviations`, which takes as input a set of words and returns the original set with added unique abbreviations for the set. (Note the input words are also abbreviations in the context of this module.)

A **word** satisfies the Raku regex: `$word ~~ /\S+/` which is quite loose. Using programs can of course further restrict that if need be. For example, for use with module **Opt::Handler** words must satisfy this regex: `$word ~~ /<ident>/`.

The input word set can be in one of three forms: (1) a list (recommended), (2) a string containing the words separated by spaces, or (3) a hash with the words as keys. Duplicate words will be automatically and quietly eliminated (at some slight extra processing cost), but you can use the ':warn' option if you want to be notified. An empty input word set will throw an exception.

Note the input word set not modify any characters unless the `:same-case` option is used.

One will normally get the result as a `Hash`, but the return type can be specified if desired by selecting either option `:Str` or option `:List` (the `:List` takes precedence silently if both are selected):

    my $abbrevs = abbrevs $words, :Str;
    my @abbrevs = abbrevs $words, :List;

Note the results as `Str` or `List` will contain the original words as well as any other valid abbreviated form, and the words will be sorted in either case. The `Hash` returned will have input words as keys whose value will be either empty strings for those keys without a shorter abbreviation or a sortedcstring of one or more valid but shorter abbreviations for others.

One other point about the process: the input word set is first formed into subgroups based on the Unicode group of the first character of each word as shown in Table 1. Then the subgroups have their abbreviation sets formed, then all those sets are combined into one set. The result will be a larger number of available abbeviations in many cases.

### Table 1. Leading character subgroups

<table class="pod-table">
<thead><tr>
<th>Group</th> <th>Unicode regex class</th>
</tr></thead>
<tbody>
<tr> <td>Lower-case letter</td> <td>&lt;:LI&gt;</td> </tr> <tr> <td>Upper-case letter</td> <td>&lt;:Lu&gt;</td> </tr> <tr> <td>Number</td> <td>&lt;:N&gt;</td> </tr> <tr> <td>Symbol</td> <td>&lt;:S&gt;</td> </tr> <tr> <td>Punctuation</td> <td>&lt;:P&gt;</td> </tr> <tr> <td>Other</td> <td>none of the above</td> </tr>
</tbody>
</table>

For example, given an input set consisting of the words

    A
    ab
    Abcde

the default hash of abbreviations (with the original words as keys) is

        A     => '',
        ab    => 'a',
        Abcde => 'Abcd Abc Ab',

If the `:same-case` option is used we get a surprisingly different result.

    my $words = 'A ab Abcde':
    my %abbr = abbrevs $words, :same-case;

The result is

        a     => '',
        ab    => '',
        abcde => 'abcd abc'

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

