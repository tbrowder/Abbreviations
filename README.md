[![Build Status](https://travis-ci.com/tbrowder/Abbreviations.svg?branch=master)](https://travis-ci.com/tbrowder/Abbreviations)

NAME
====

Abbreviations - provides abbreviations for an input set of one or more words

SYNOPSIS
========

```raku
use Abbreviations;
my $words = 'a ab abcde';
my %abbrevs = abbreviations $words;
```

DESCRIPTION
===========

**Abbreviations] is a module with one exported multi subroutine, `abbreviations`, which takes as input a set of words and returns the original set with added unique abbreviations for the set. (Note the input words are also abbreviations in the context of this module.) A **word** satisfies the Raku regex: `$word ~~ /\S+/` which is quite loose. Using programs can of course further restrict that if need be. For example, for use with module **Opt::Handler** words must satisfy this regex: `$word ~~ /<ident>/`. The input word set can be in one of three forms: (1) a string containing the words separated by spaces, (2) a list, or (3) a hash with the words as keys. Duplicate words will be automatically eliminated, but you can use the ':warn' option if you want to be notified. One will normally get the result in the same form as the input set, e.g., a list input will return a list, but the return type can be specified if desired. Note the results as string or list will contain the original words as well as any other valid abbreviated form. The hash returned will have input words as keys whose value will be either empty strings for those keys without a shorter abbreviation or a string of one or more valid but shorter abbreviations for others. For example, given an input set consisting of the words a ab abcde the list of abbreviations (which incudes the original words) is a ab abc # <== abbreviation for abcde abcd # <== abbreviation for abcde abcde One can also ask for a hash which will show the abbreviations attached as a string to the parent word. That result for the previous input example is a => '', ab => '', abcde =** 'abc abcd'

AUTHOR
======

Tom Browder <tom.browder@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

