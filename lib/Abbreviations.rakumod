unit module Abbreviations;

enum Out-type is export <S L AH AL H>;

# define  "aliases" for convenience
our &abbrevs is export         = &abbreviations;
our &abbrev  is export         = &abbreviations;
our &abbre   is export(:abbre) = &abbreviations;
our &abbr    is export(:abbr)  = &abbreviations;
our &abb     is export(:abb)   = &abbreviations;
our &ab      is export(:ab)    = &abbreviations;
our &a       is export(:a)     = &abbreviations;

sub get-abbrevs(@abbrev-words, :$debug --> Hash) is export {
    # @ow - A list of original, unique words (downcased if desired)
    my @ow = @abbrev-words;
    my %ow;
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

    # delete all abbrevs not having exactly one word associated with it
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

    # TODO remove this annoying extra step by changing the caller or this sub!!!
    # the hash needs to be converted to the default H (Hash) type because of the needs of the caller
    my %m;
    for %abbrevs.kv -> $a, $w {
        if %m{$w}:exists {
            %m{$w}.push: $a;
        }
        else {
            %m{$w} = [];
            %m{$w}.push: $a;
        }
    }
    # now add the word as an abbreviation for itself
    for %ow.keys -> $w {
        %m{$w}.push: $w;
    }

    # ensure the lists are properly sorted
    for %m.kv -> $w, $abbrev-list {
        my @w = sort-list @($abbrev-list);
        %m{$w} = @w;
    }

    %m;

} # sub get-newabbrevs

sub abbreviations($word-set,
                  Out-type :$out-type = H,
                  :$lower-case,
                  :$debug,
                 ) is export {
    # Given a set of words, determine the shortest unique abbreviation
    # for each word.

    my @abbrev-words;
    my @input-order; # holds the original order before any lower-casing
    my @input-order-lower-case;

    # Determine the input type and generate the input word lists accordingly
    if $word-set ~~ Str {
        @abbrev-words = $word-set.words;
        @input-order  = @abbrev-words;
    }
    elsif $word-set ~~ List {
        @abbrev-words = @($word-set);
        @input-order  = @abbrev-words;
    }
    else {
        die "FATAL: Cannot handle word set format '{$word-set.^name}'";
    }

    if not @abbrev-words.elems {
        die "FATAL: Empty input word set.";
    }

    # Remove any dups
    @abbrev-words .= unique;
    @input-order  = @abbrev-words;

    if $lower-case {
        $_ .= lc for @abbrev-words;
        @abbrev-words .= unique;
        @input-order-lower-case = @abbrev-words;
    }

    # Use the output hash to assemble other output formats
    my %m = get-abbrevs @abbrev-words, :$debug;

    # The hash output is %m and ready to go (keys are words)
    return %m if $out-type ~~ H; # 'Hash'

    # The list and string output formats will have all words (keys) and abbreviations
    # sorted by default then length (shortest first)
    my @ow;
    for %m.kv -> $k, $abbrev-list {
        my @list = @($abbrev-list);
        @ow.push: |@list;
    };
    @ow = sort-list @ow;

    return @ow if $out-type ~~ L; # 'List'
    return @ow.join(' ') if $out-type ~~ S; # 'String';

    if $out-type ~~ AH {
        #=== Output hash converted to AbbrevHash:
        # The AbbrevHash is keyed by all abbreviations for
        # each word and its value is that word.
        my %ah;
        for %m.kv -> $word, $abbrev-list {
            for @($abbrev-list) -> $abbrev {
                note "ERROR: Unexpected dup abbrev '$abbrev' for word '$word'" if %ah{$abbrev}:exists;
                %ah{$abbrev} = $word;
            }
        }
        note "DEBUG: out-type(AH) in words: {@ow}" if $debug;
        note "DEBUG:               abbrevs: {%ah.raku}" if $debug;
        return %ah;
    }

    if $out-type ~~ AL {
        #=== Output hash converted to AbbrevList:
        # The AbbrevList is the list of the min abbreviations for
        # each word in the original input order.
        my @al;
        my @in = @abbrev-words;
        for @in -> $w {
            # for each word, add its min abbrev to the list
            my $m = @(%m{$w})[0];
            @al.push: $m;
        }
        note "DEBUG: out-type(AL) in words: {@in}" if $debug;
        note "DEBUG:               abbrevs: {@al}" if $debug;
        return @al;
    }

    die "FATAL: Should not reach this line.";

} # end sub abbreviations

sub sort-list(@list is copy, :$longest-first) is export(:auto, :sort) {
    # always sort by standard sort first
    @list .= sort;
    return @list.sort({$^b.chars cmp $^a.chars}) if $longest-first;
    # sort by shortest word first
    @list.sort({$^a.chars cmp $^b.chars});
}
