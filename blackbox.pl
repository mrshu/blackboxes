use strict;
use warnings;
use 5.14.0;

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

sub rmaker {
    return sub {
        rt(rand(5) + 1)
    };
}

my $n = rmaker();

my @alp = ('a' .. 'z');
my ($l, $m) = (ord (substr (&$n, 1, 1)) % 26, $ENV{USER});
for my $x (@alp) {
    mkdir "$x";
    for my $y (@alp) {
        mkdir "$x/$x$y";
        for my $a (1..15) {
            c("$x/$x$y/$x$y-subor$a", &$n);
            next unless $y eq $alp[$l];
            c("$x/$x$y/-subor$a.$x$y", &$n);
            next unless $y eq $alp[($l+rand(5))%26] and $y eq $alp[$l];
            c("$x/$x$y/--subor$a.$x$y", &$n);
            next unless $y eq $alp[($l+rand(5))%26] and $y eq $alp[$l] and $x ne $y;
            c("$x/$x$y/.-subor$a", $m);
        }
    }
}
