[![Actions Status](https://github.com/tbrowder/Abbreviations/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Abbreviations/actions) [![Actions Status](https://github.com/tbrowder/Abbreviations/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Abbreviations/actions) [![Actions Status](https://github.com/tbrowder/Abbreviations/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Abbreviations/actions)

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
say %abbrevs.gist;
# OUTPUT: «{A => A, Abcde => Ab, ab => a}␤»
```

DESCRIPTION
===========

**Abbreviations** is a module with one automatically exported subroutine, `abbreviations`, which takes as input a set of words and returns the original set with added unique abbreviations for the set. (Note the input words are also abbreviations in the context of this module.)

Its signature:

    sub abbreviations($word-set,      #= Str, List, or Hash (Set)
                     :$out-type = HA, #= the default, HashAbbrev
                     :$lower-case,    #= convert the word st to lowercase
                     :$min-length,    #= minimum abbreviation length
                     ) is export {...}

A *word* satisfies the Raku regex `$word ~~ /\S+/` which is quite loose. Using programs can of course further restrict that if need be. For example, for use with module **Opt::Handler** words must satisfy this regex: `$word ~~ /<ident>/`.

The input word set can be in one of three forms: (1) a list (recommended), (2) a string containing the words separated by spaces, or (3) as a hash (or set) with the words being keys of the hash (set members). Duplicate words will be automatically and quietly eliminated.

Note the input word set will not be modified unless the `:lower-case` option is used. In that case, all characters will be transformed to lower-case and any new duplicate words deleted.

If the user wishes, he or she can restrict the minimum length of the generated abbreviations by using the `:$min-length` parameter.

One will normally get the result as a hash with the input words as keys with their shortest abbreviation as values (return type HA), but the return type can be specified via `enum Out-type` if desired by selecting one of the `:$output-type` options. For example:

    my %abbrevs = abbrevs @words, :output-type(AH);

There are two shorter alias names for `sub abbreviations` one can use that are always exported:

```raku
 abbrevs
 abbrev
```

In the sprit of the module, one can `use Abbreviations :ALL;` and have these additional shorter alias names available:

```raku
 abbre
 abbr
 abb
 ab
 a
```

Each of those is individually available by adding its name as an adverb, for example:

```raku
use Abbreviations :abb;
my %abb = abb $words;
```

### `enum Out-type`

    enum Out-type is export <HA H AH AL L S >;

The *enum* `Out-type` is exported automatically as it is required for using `sub abbreviations`. It has the following types:

  * `HA` (HashAbbrev)

The default *HashAbbrev* (`HA`) returned will have input words as keys whose value will be the shortest valid abbreviation.

  * `H` (Hash)

A variant of `HA`, the *Hash* (`H`) returned will have input words as keys whose value will be a sorted list of its valid abbreviations (sorted by length, shortest first, then by `Str` order).

  * `AH` (AbbrevHash)

An *AbbrevHash* (`AH`) is keyed by all of the valid abbreviations for the input word list and whose values are the word from which that abbreviation is defined.

  * `AL` (AbbrevList)

An *AbbrevList* (`AL`) is special in that the returned list is the one, shortest abbreviation for each of the input words in input order. For example,

    my @w = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
    my @abb = abbrevs @w, :output-type(AL);
    say @abb; # OUTPUT: «M Tu W Th F Sa Su␤»

Note that a hash (or set) input type will not reliably provide this output as expected since the keys are not stored in order. Instead, the ouput will be based on a list of the hash's keys. In effect, entering `%out = abbreviations %in` is the same as:

    my @inputlist = %in.keys.sort({.chars, .Str}';
    my %out = abbreviations @inputlist;

  * `L` (List)

A *List* (`L`) contains all of the valid abbreviations for the input word list, including the words themselves, sorted by length, then character order.

  * `S` (String)

A *String* (`S`) is the string formed by joining the *List* by a single space between words.

### Improved abbreviation search

The abbreviation algorithm has been improved from the original (as found on [https://rosettacode.org](https://rosettacode.org)) in the following way: The input word set is formed into subgroups comprised of each input word. Abbreviations are created for each word, abbreviations shared by two or words are eliminated, then all those abbreviations are combined into one set. The result will be the largest possible set of unique abbreviations for a given input word set.

For example, given an input set consisting of the words `A ab Abcde`, the default output hash of abbreviations (with the original words as keys) contains a total of seven abbreviations:

        A     => ['A'],
        ab    => ['a', 'ab'],
        Abcde => ['Ab', 'Abc', 'Abcd', 'Abcde'],

If the `:lower-case` option is used, we get a slightly different result since we have fewer unique abbreviations from the lower-cased words. The new hash has only five abbreviations:

    my $words = 'A ab Abcde':
    my %abbr = abbrevs $words, :lower-case;

The result is

        a     => ['a'],
        ab    => ['ab],
        abcde => ['abc', 'abcd', 'abcde'],

Notice the input word **ab** now has only one abbreviation and **abcde** has only three.

Other exported symbols
----------------------

### `sub sort-list`

    sub sort-list(@list, :$type = SL, :$reverse --> List) is export(:sort)
    {...}

By default, this routine sorts all lists by word length, then by Str order. The order by length is by the shortest abbreviation first unless the `:$reverse` option is used. This is the routine used for all the output types produced by this module *except* the *AbbrevList* (`AL`) which keeps the original word set order.

The routine's output can be modified for other uses by entering the `:$type` parameter to choose another of the <enum Sort-type>s.

### `enum Sort-type`

    enum Sort-type is export(:sort) < SL LS SS LL N>;

The `Sort-type`s are:

  * SL - order by Str, then order by Length

  * LS - order by Length, then order by Str

  * SS - Str order only

  * LL - Length order only

  * N - Numerical order only (falls back to SS if any words are not numbers)

AUTHOR
======

Tom Browder <tbrowder@acm.org>

CREDITS
=======

  * Leon Timmermans (aka @Leont) for inspiration from his Raku module `Getopt::Long`.

  * @thundergnat, the original author of the Raku `auto-abbreviate` algorithm on [Rosetta Code](http://rosettacode.org/wiki/Abbreviations,_automatic#Raku).

  * The Raku community for help with subroutine signatures.

COPYRIGHT and LICENSE
=====================

Copyright © 2020-2023 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

