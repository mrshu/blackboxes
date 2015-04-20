use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
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
        rt(rand(20) + 1)
    };
}

sub r {
    my ($filename) = @_;
    local $/ = undef;
    open(LEVEL, $filename);
    binmode LEVEL;
    my $contents = <LEVEL>;
    close LEVEL;
    return $contents;
}

sub ch {
    my ($f) = @_;
    my $a = `ps aux|grep $f|grep -v grep|wc -l`;
    return $a;
}

my $n = rmaker();

die "usage: $0 ID\n" if (scalar @ARGV < 1);
my $ID = $ARGV[0];

my @files;
my @tries;
my $file = '';

foreach (<DATA>) {
    if ($_ =~ "========== ([0-9]+)") {
        push @files, $file;
        push @tries, $1;
        $file = '';
        next;
    } else {
        $file .= $_;
    }
}

die "Invalid number of level!\n" if ($ID >= scalar @files || $ID < 0);

if ($ID == 0) {
    my $f = 'virus'.&$n.'.pl';
    c($f, $files[$ID]);
    system("perl $f&");
}

if ($ID == 1) {
    foreach my $i (1 .. 30) {
        my $f = 'virus'.&$n.'.pl';
        c($f, $files[$ID]);
        system("perl $f&");
    }
}

my $pa = ch('virus.\*.pl');
my $tries = 0;
print ("> ");
while (<STDIN>) {
    my $a = ch('virus.\*.pl');
    if ($pa > $a) {
        die "Malicious intent detected. Please report yourself to the nearest academic authority.\n";
    }

    system ($_);
    $a = ch('virus.\*.pl');
    $pa = $a;
    if ($a == 0) {
        die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($ID).md5_hex(r($0))). "\n";
    }
    $tries = $tries + 1;
    if ($tries > $tries[$ID]) {
        die "Sorry, you have reached the number of tries allowed for this excercise. Try again!\n";
    }
    print ("> ");
}

__END__
while(1) {
    sleep(5);
}
========== 10
while(1) {
    sleep(5);
}
========== 20
