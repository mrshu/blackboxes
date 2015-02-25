use strict;
use warnings;

srand(1234);

sub rt {
    my ($n) = @_;
    return join '' => map chr(int(rand(26)) + 97), 1 .. $n;
}

sub c {
    my ($path, $text) = @_;
    open my $h, '>', $path;
    print $h $text;
    close $h;
}

my @alp = ('a' .. 'z');

for my $x (@alp) {
    mkdir "$x";
    for my $y (@alp) {
        mkdir "$x/$x$y";
        for my $a (1..15) {
            c("$x/$x$y/$x$y-subor$a", rt((rand(3) + 1)));
        }
    }
}
