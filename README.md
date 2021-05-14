[![Actions Status](https://github.com/tbrowder/Abbreviations/workflows/test/badge.svg)](https://github.com/tbrowder/Abbreviations/actions)

NAME
====

Abbreviations - Provides abbreviations for an input set of one or more words

**NOTE: THIS VERSION IS API 2 AND HAS VERY DIFFERENT FEATURES COMPARED TO THE ORIGINAL API.**

SYNOPSIS
========

```raku
use Abbreviations;
my $words = 'A ab Abcde';
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

**Abbreviations** is a module with one automatically exported subroutine, `abbreviations`, which takes as input a set of words and returns the original set with added unique abbreviations for the set. (Note the input words are also abbreviations in the context of this module.)

A *word* satisfies the Raku regex: `$word ~~ /\S+/` which is quite loose. Using programs can of course further restrict that if need be. For example, for use with module **Opt::Handler** words must satisfy this regex: `$word ~~ /<ident>/`.

The input word set can be in one of two forms: (1) a list (recommended) or (2) a string containing the words separated by spaces. Duplicate words will be automatically and quietly eliminated.

Note the input word set will not be modified unless the `:lower-case` option is used. In that case, all characters will be transformed to lower-case.

One will normally get the result as a hash, but the return type can be specified via an `enum` if desired by selecting one of the `:output-type` options: `AH` (AbbrevHash), `AL` (AbbrevList), `H` (Hash), `L` (List), or `S` (String). For example,

    my %abbrevs = abbrevs @words, :output-type(AH);

### Output types by enum

  * `H` (Hash)

The default *Hash* (`H`) returned will have input words as keys whose value will be a sorted list of one or more valid abbreviations (sorted by length, shortest first).

  * `AH` (AbbrevHash) 

An *AbbrevHash* (`AH`) is keyed by all of the valid abbreviations for the input word list and whose values are the word from which that abbreviation is defined.

  * `AL` (AbbrevList)

An *AbbrevList* (`AL`) is special in that the returned list is the one, shortest abbreviation for each of the input words in input order. For example,

    my @w = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
    my @abb = abbrevs @w, :lower-case, :output-type(AL);
    say @abb; # OUTPUT: m tu w th f sa su

  * `L` (List) 

A *List* (`L`) contains all of the valid abbreviations for the input word list, including the words themselves, sorted first be the default Raku sort and then by length (shortest first).

  * `S` (String)

A *String* (`S`) is the string formed by joining the **List** by a single space.

One other point about the new abbreviation process: the input word set is first formed into subgroups based on the the first character of each word. Then the subgroups have their abbreviation sets formed, then all those sets are combined into one set. The result will be a larger number of available abbeviations in many cases than were available under the original API.

For example, given an input set consisting of the words `A ab Abcde`, the default output hash of abbreviations (with the original words as keys) is

        A     => ['A'],
        ab    => ['a', 'ab'],
        Abcde => ['Ab', 'Abc', 'Abcd', 'Abcde'],

If the `:lower-case` option is used we get a surprisingly different result.

    my $words = 'A ab Abcde':
    my %abbr = abbrevs $words, :lower-case;

The result is

        a     => ['a'],
        ab    => ['ab],
        abcde => ['abc', 'abcd', 'abcde'],

Notice the input word **ab** now has only one abbreviation and **abcde** has only three.

Exported symbols
----------------

### `sort-list`

    sub sort-list(@list, :longest-first --> List) is export(:sort) 
    {...}

The routine sorts the input list first by the default Raku sort and then by word length. The order by length is by shortest first unless the `:longest-first` option is used.

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

CREDITS
=======

  * Leon Timmermans (aka @Leont) for inspiration from his Raku module `Getopt::Long`.

  * @thundergnat, the original author of the Raku `auto-abbreviate` algorithm on [Rosetta Code](http://rosettacode.org/wiki/Abbreviations,_automatic#Raku).

  * The Raku community for help with subroutine signatures.

COPYRIGHT and LICENSE
=====================

Copyright &#x00A9; 2020-2021 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

