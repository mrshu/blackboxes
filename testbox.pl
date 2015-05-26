use strict;
use warnings;
use 5.14.0;

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
        rt(rand(10))
    };
}

my $n = rmaker();

my @alp = ('a' .. 'z', 'A' .. 'Z', '0' .. '9');
my ($l, $m) = (ord (substr (&$n, 1, 1)) % 26, $ENV{USER});
for my $x (1 .. 5) {
    my $a;
    $a .= $alp[rand @alp] for 1..8;
    mkdir "$a";
    for my $y (1 .. 5) {
        my $b;
        $b .= $alp[rand @alp] for 1..8;
        mkdir "$a/$b";
        for my $z (1 .. 5) {
            my $c;
            $c .= $alp[rand @alp] for 1..8;
            my $p;
            $p .= $alp[rand @alp] for 1..3;
            c("$a/$b/$c.$p", '')
        }
    }
    for my $z (1 .. 5) {
        my $c;
        $c .= $alp[rand @alp] for 1..8;
        my $p;
        $p .= $alp[rand @alp] for 1..3;
        c("$a/$c.$p", '');
    }

}
