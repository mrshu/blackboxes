#!/usr/bin/env perl
use strict;
use warnings;
use File::Temp qw(tempfile);
use Digest::MD5 qw(md5_hex);
use 5.014;

sub c {
    my ($path, $text) = @_;
    open my $h, '>', $path;
    print $h $text;
    close $h;
}

my @config = (
    'backspace=2',
    'scrolloff=3',
    'ruler',
    'showcmd',
    'ruler',
    'hlsearch',
);

my @levels;
my @solutions;
my @presses;
my $flag = 0;
my $level = '';
my $solution = '';

foreach (<DATA>) {
    if ($_ =~ "---------- ([0-9]+)") {
        push @presses, $1;
        push @levels, $level;
        $level = '';
        $flag = 1;
        next;
    } elsif ($_ =~ "==========") {
        push @solutions, $solution;
        $solution = '';
        $flag = 0;
        next;
    }

    if ($flag == 0) {
        $level .= $_;
    } elsif ($flag == 1) {
        $solution .= $_;
    }
}

die "usage: $0 ID\n" if (scalar @ARGV < 1);
my $ID = $ARGV[0];

die "Invalid number of level!\n" if ($ID >= scalar @levels || $ID < 0);

my (undef, $levelfile) = tempfile();
my (undef, $vimfile) = tempfile();
c($levelfile, $levels[$ID]);
system("vim -N --cmd 'set ". join(' ', @config) ."' -u NONE -w $vimfile $levelfile");

open(LEVEL, $levelfile);
$level = <LEVEL>;
open(VIMOUT, $vimfile);
my $vimout = <VIMOUT>;

if (length $vimout > $presses[$ID]) {
    die "Sorry, you have used more key presses than allowed ($presses[$ID]). Try again!\n";
}
if ($solutions[$ID] ne $level) {
    die "Sorry, your output file does not match our correct output file. Try again!\n";
}

die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($level)."VIM$presses[$ID]OUT") . "\n";

__END__
As you no doubt realize by now, Perl has some really odd features, and the DATA file handle is one of them. This file handle lets you store read-only data in the same file as your Perl script, which might come in handy if you need to send both code and data to someone via e-mail.
---------- 10
As you no doubt realize by now, has some really odd features, and the DATA file handle is one of them. This file handle lets you store read-only data in the same file as your Perl script, which might come in handy if you need to send both code and data to someone via e-mail.
==========
