unit module Abbreviations;

enum Out-type  is export < S L AH AL H HA >; # String, List, AbbrevHash, Hash, HashAbbrev
enum Sort-type is export < SL LS SS LL>;     # StrLength, LengthStr, Str, Length

# define  "aliases" for convenience
our &abbrevs is export         = &abbreviations;
our &abbrev  is export         = &abbreviations;
our &abbre   is export(:abbre) = &abbreviations;
our &abbr    is export(:abbr)  = &abbreviations;
our &abb     is export(:abb)   = &abbreviations;
our &ab      is export(:ab)    = &abbreviations;
our &a       is export(:a)     = &abbreviations;

#| The calling program
sub abbreviations($word-set,
                  :$out-type = HA, #= the default
                  :$lower-case,
                  :$min-length,    #= minimum abbreviation length
                  :$debug,
                 ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word.

    my @abbrev-words;
    my @input-order; #= holds the original order but modified to remove 
                     #= dups and any lower-casing

    # Determine the input type and generate the input word lists accordingly
    if $word-set ~~ Str {
        @abbrev-words = $word-set.words;
        @input-order  = @abbrev-words;
    }
    elsif $word-set ~~ List {
        @abbrev-words = $word-set.words;
        @input-order  = @abbrev-words;
    }
    elsif $word-set ~~ Hash {
        @abbrev-words = sort-list $word-set.keys;
        @input-order  = @abbrev-words; # check docs, also add a test to check it
    }
    else {
        die "FATAL: Cannot handle word set format '{$word-set.^name}'";
    }

    if not @abbrev-words.elems {
        die "FATAL: Empty input word set.";
    }

    # Remove any dups
    @abbrev-words .= unique;
    @input-order   = @abbrev-words;

    if $lower-case {
        $_ .= lc for @abbrev-words;
        @abbrev-words .= unique;
        @input-order   = @abbrev-words;
    }

    # Use the output hash to assemble other output formats
    my $abbrev-out-type;
    with $out-type {
        when $_ ~~ HA { $abbrev-out-type = HA }
        when $_ ~~ AL { $abbrev-out-type = HA }
        default       { $abbrev-out-type = H  }
    }

    my %m = get-abbrevs @abbrev-words, :$abbrev-out-type, :$min-length, :$debug;

    # The hash output is %m and ready to go (keys are words)
    return %m if $out-type ~~ HA|H; # 'Hash'

    # The list and string output formats will have all words (keys) and abbreviations
    # sorted by string order then length.
    my @ow;
    for %m.kv -> $k, $abbrev-list {
        my @list = $abbrev-list.words;
        @ow.push($_) for @list;
    };
    @ow = sort-list @ow;

    return @ow           if $out-type ~~ L; # 'List'
    return @ow.join(' ') if $out-type ~~ S; # 'String';

    if $out-type ~~ AH {
        #=== Output hash converted to AbbrevHash:
        # The AbbrevHash is keyed by all abbreviations for
        # each word and its value is that word.
        my %ah;
        for %m.kv -> $word, $abbrev-list {
            for $abbrev-list.words -> $abbrev {
                note "ERROR: Unexpected dup abbrev '$abbrev' for word '$word'" if %ah{$abbrev}:exists;
                %ah{$abbrev} = $word;
            }
        }
        note "DEBUG: out-type(AH) in words: {@ow}" if $debug;
        note "DEBUG:               abbrevs: {%ah.raku}" if $debug;
        return %ah;
    }

    if $out-type ~~ AL {
        #=== Output hash (HA) converted to AbbrevList:
        # The AbbrevList is the list of the min abbreviations for
        # each word in the original input order.
        my @al;
        my @in = @input-order;
        for @in -> $w {
            # for each word, add its min abbrev to the list
            @al.push: %m{$w};
        }

        note "DEBUG: out-type(AL) in words: {@in}" if $debug;
        note "DEBUG:               abbrevs: {@al}" if $debug;
        return @al;
    }

    die "FATAL: Should not reach this line.";

} # end sub abbreviations

#| This sub is called by sub abbreviations
sub get-abbrevs(@abbrev-words, :$abbrev-out-type!, :$min-length, :$debug --> Hash) {
    # @ow - A list of original, unique words (downcased if desired)
    my @ow = @abbrev-words;
    my %ow; # a hash to hold the words to be abbreviated
    %ow{$_} = 1 for @ow;

    # %abbrevs  - The final solution should be in the hash with its
    #       keys being the list of valid abbreviations
    #    and its value the using $word.
    my %abbrevs; # keys are abbrevs, value list of using words

    for @ow -> $word {
        my $n = $word.chars;
        die "FATAL: zero word length" if not $n;
        # IMPORTANT: at this stage of the collection, the $word is NOT an abbreviation
        #            but it will be added later.
        for 1..$n {
            my $abbrev = $word.substr(0, $_);
            next if %ow{$abbrev}:exists;
            if %abbrevs{$abbrev}:exists {
                %abbrevs{$abbrev}.push: $word;
            }
            else {
                %abbrevs{$abbrev} = [];
                %abbrevs{$abbrev}.push: $word;
            }
        }
    }

    # Delete all abbrevs not having exactly one word associated with it
    for %abbrevs.kv -> $abbrev, $wordlist {
        my $nw = $wordlist.elems;
        if $nw != 1 {
            %abbrevs{$abbrev}:delete;
        }
    }

    if $debug {
        note "DEBUG: dumping %abbrev hash:";
        note %abbrevs.raku;
    }

    # The hash will later be converted to the default HA (Hash) type unles
    # the caller wants another type. In that case, the H type will
    # be returned and processed further if need be.
    my %m; # will hold the hash of words and their abbrevs
    for %abbrevs.kv -> $a, $w {
        if $min-length.defined {
            next if $a.chars < $min-length;
        }

        if %m{$w}:exists {
            %m{$w}.push: $a;
        }
        else {
            %m{$w} = [];
            %m{$w}.push: $a;
        }
    }
    # Add the word as an abbreviation for itself
    for %ow.keys -> $w {
        %m{$w}.push: $w;
    }

    # Ensure the lists are properly sorted
    for %m.kv -> $w, $abbrev-list {
        my @w = sort-list $abbrev-list.words;
        if $abbrev-out-type ~~ HA {
            %m{$w} = @w.head;
        }
        else {
            %m{$w} = @w;
        }
    }

    %m

} # sub get-abbrevs

# enum Sort-type is export < SL LS SS LL>;    # StrLength, LengthStr, Str, Length
sub sort-list(@List, :$type = LS, :$reverse) is export(:auto, :sort) {
    my @list = @List; 
    if $type ~~ SL {
        @list .= sort({.Str, .chars});
    }
    elsif $type ~~ LS {
        @list .= sort({.chars, .Str});
    }
    elsif $type ~~ LL {
        @list .= sort({.chars});
    }
    elsif $type ~~ SS {
        @list .= sort({.Str});
    }

    @list .= reverse if $reverse;
    @list
} # end sub sort-list
