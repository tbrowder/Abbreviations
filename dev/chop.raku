my $ifil = "system-fonts.list";
my $ofil = "abbrev-test.list";
my $fh = open $ofil, :w;

for $ifil.IO.lines -> $line {
    my @w = $line.words;
    my $w = @w[1];
    $fh.say: $w;
}
$fh.close;

