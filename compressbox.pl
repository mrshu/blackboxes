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

sub u {
    my $s = shift;
    $s =~ tr/!-~/P-~!-O/;
    return $s;
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

sub cm {
    my ($f, $t, $i) = @_;
    my $j = $i - 1;
    my $o = $f;
    $f =~ s/\.$j/\.$i/;
    system("tar -c" . $t . "f $f $o");
    unlink("$o");
    return $f;
}

srand(hex(substr(md5_hex($ENV{USER}), -5)));

my $file = 'data.0';
c($file, "The password is: " . md5_hex($ENV{USER}.md5_hex(r($0))) . "\n");
foreach my $c (1 .. 8) {
    my $r = int(rand(4));
    if ($r == 0)  {
        $file = cm($file, 'z', $c);
    } elsif ($r == 1) {
        $file = cm($file, 'j', $c);
    } elsif ($r == 2) {
        $file = cm($file, 'J', $c);
    } else {
        $file = cm($file, '', $c);
    }
}

rename("$file", $file =~ s/\.\d/\.compressed/r);
print "Your file is located at " . $file =~ s/\.\d/\.compressed/r . ". Good luck!";
