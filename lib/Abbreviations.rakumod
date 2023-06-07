unit module Abbreviations;

enum Out-type is export <S L AH AL H HA>;

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
                  :$out-type = HA,
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
    elsif $word-set ~~ Hash {
        @abbrev-words = $word-set.keys;
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
    @input-order  = @abbrev-words;

    if $lower-case {
        $_ .= lc for @abbrev-words;
        @abbrev-words .= unique;
        @input-order-lower-case = @abbrev-words;
    }

    # Use the output hash to assemble other output formats
    # If the input out-type ~~ HA, we are finished
    my $abbrev-out-type = $out-type ~~ HA ?? HA !! H;
    my %m = get-abbrevs @abbrev-words, :$abbrev-out-type, :$debug;

    # The default now is to have the only value be the shortest abbreviation.
    # The hash output is %m and ready to go (keys are words)
    return %m if $out-type ~~ HA|H; # 'Hash'

    # The list and string output formats will have all words (keys) and abbreviations
    # sorted by default then length (shortest first)
    my @ow;
    for %m.kv -> $k, $abbrev-list {
        my @list = @($abbrev-list);
        @ow.push: |@list;
    };
    @ow .= sort;
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
        #my @in = @abbrev-words;
        my @in = @input-order;
        for @in -> $w {
            # for each word, add its min abbrev to the list
            my $m;
            if $out-type ~~ H {
                $m = %m{$w}.head
            }
            else {
                $m = %m{$w};
            }
            @al.push: $m;
        }

        note "DEBUG: out-type(AL) in words: {@in}" if $debug;
        note "DEBUG:               abbrevs: {@al}" if $debug;
        return @al;
    }

    die "FATAL: Should not reach this line.";

} # end sub abbreviations

#| This sub is called by sub abbreviations
sub get-abbrevs(@abbrev-words, :$abbrev-out-type!, :$debug --> Hash) is export(:get-abbrevs) {
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
    # be returned and processed futher if need be.
    my %m; # will hold the hash of words and their abbrevs
    for %abbrevs.kv -> $a, $w {
        if %m{$w}:exists {
            %m{$w}.push: $a;
        }
        else {
            %m{$w} = [];
            %m{$w}.push: $a;
        }
    }
    # Now add the word as an abbreviation for itself
    for %ow.keys -> $w {
        %m{$w}.push: $w;
    }

    # Ensure the lists are properly sorted
    #my %h;
    for %m.kv -> $w, $abbrev-list {
        my @w = sort-list @($abbrev-list);
        if $abbrev-out-type ~~ HA {
            #%h{$w} = @w.head;
            %m{$w} = @w.head;
        }
        else {
            #%h{$w} = @w;
            %m{$w} = @w;
        }
    }

    #%h
    %m

} # sub get-abbrevs

sub sort-list(@list is copy, :$longest-first) is export(:auto, :sort) {
    # always sort by standard sort first
    @list .= sort;

    return @list.sort({$^b.chars cmp $^a.chars}) if $longest-first;

    # sort by shortest word first
    @list.sort({$^a.chars cmp $^b.chars});
} # end sub sort-list

=finish

#| Two subs from Chapter 32 of "Introduction to Algorithms", String Matching
#| KMP-Matcher(T,P)
=begin comment
 1  n = T.length
 2  m = P.length
 3  pi = Compute-Prefix-Function(P)
 4  q = 0                                            // number of characters matched
 5  for i = 1 to n                                   // scan the text from left to right
 6      while q > 0 and P[q + 1] not equal T[i]
 7          q = pi[q]                                // next character does not match
 8      if P[q + 1] == T[i]
 9          q = q + 1                                // next character matches
10      if q == m                                    // is all of P matched?
11          print "Pattern occurs with shift" i - m
12          q = pi[q]                                // look for the next match
=end comment
sub KMP-Matcher(@T, @P) {
    my $n = @T.elems; # length
    my $m = @P.elems; # length
    my @pi = Compute-Prefix-Function(@P);
    my $q = 0;                                           # number of characters matched
    for 1..$n -> $i { # i = 1 to n                       # scan the text from left to right
        while $q > 0 and @P[$q + 1] != @T[$i] {
            $q = @pi[$q];                                # next character does not match
        }
        if @P[$q + 1] == @T[$i] {
            $q = $$q + 1;                                # next character matches
        }
        if $q == $m {                                    # is all of P matched?
            # print "Pattern occurs with shift" i - m
            $q = @pi[$q];                                # look for the next match
        }
    }
}

#| Compute-Prefix-Function(P)
=begin comment
 1  m = P.length
 2  let pi[1..m] be a new array
 3  pi[1] = 0
 4  k = 0
 5  for q = 2 to m
 6      while k > 0 and P[k + 1] not equal P[q]
 7          k = pi[k]
 8      if P[k + 1] == P[q]
 9          k = k + 1
10      pi[q] = k
11  return pi
=end comment
sub Compute-Prefix-Function(@P) {
    my $m = @P.elems;
    my @pi;                                     # let pi[1..m] be a new array
    @pi[1] = 0;
    my $k = 0;
    for 2..$m -> $q {                           # for q = 2 to m
        while $k > 0 and @P[$k + 1] != @P[$q] { #     while k > 0 and P[k + 1] not equal P[q]
            $k = @pi[$k];                       #         k = pi[k]
            if @P[$k + 1] == @P[$q] {           #     if P[k + 1] == P[q]
                $k = $k + 1;                    #         k = k + 1
            }
            @pi[$q] = $k;                       #     pi[q] = k
        }
    }
    @pi                                         # return pi
}
