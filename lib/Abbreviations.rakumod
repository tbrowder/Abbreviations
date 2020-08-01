unit class Abbreviations:ver<0.0.1>:auth<cpan:TBROWDER>;

=begin pod

=head1 NAME

Abbreviations - provides a list of unique abbreviations for an input set of one
or more unique words. (Note the input words are also
abbreviations in the context of this module.)

=head1 SYNOPSIS

=begin code :lang<raku>

use Abbreviations;
my $words = 'a ab abcde';
my %abbrevs = abbreviations $words;

=end code

=head1 DESCRIPTION

Abbreviations is a module with one exported multi subroutine 'abbreviations'.

The input word set can be (1) a string containing the words separated by spaces, (2) a
list, or (3) a hash with the words as keys. Duplicate words will be
eliminated with a warning (default) or an exception if desired.

One will get the result in the same form as the input set, e.g., a list input
will return a list.
Note the results as string or list will contain
the original words as well as any other valid abbreviated form. The hash returned will have empty strings for those
keys without a shorter abbreviation and a string of one or more valid but shorter abbreviations.

(2) a list, 
or (3) a string with words separated by spaces,
(1) a hash (default) with the input words as keys and abbreviations as values (in a string
of space-separated words). 


For example, given

    a 
    ab 
    abcde

the list of abbreviations (which incudes the original words) is

    a 
    ab 
    abc    # <== abbreviation for abcde
    abcd   # <== abbreviation for abcde 
    abcde

One can also ask for a hash which will show the abbreviations
attached as a string to the parent word. That result for the previous input
example

    a     => '', 
    ab    => '',
    abcde => 'abc abcd'

=head1 AUTHOR

Tom Browder <tom.browder@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
