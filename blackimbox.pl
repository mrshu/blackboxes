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

sub r {
    my ($filename) = @_;
    local $/ = undef;
    open(LEVEL, $filename);
    binmode LEVEL;
    my $contents = <LEVEL>;
    close LEVEL;
    return $contents;
}

srand(1234);

sub rt {
    my ($n) = @_;
    return join '' => map chr(int(rand(26)) + 97), 1 .. $n;
}

sub rmaker {
    return sub {
        rt(rand(5) + 1)
    };
}

sub t {
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
}

sub fe {
    my ($f, $s) = @_;
    return r($f) eq $s;
}

sub cut {
    my ($f, $i, $d) = @_;
    return join("\n", map { (split($d, $_))[$i];  } split("\n", r($f))) . "\n";
}


my @config = (
    'backspace=2',
    'scrolloff=3',
    'ruler',
    'showcmd',
    'wrap',
    'hlsearch',
    'ffs=unix',
);

my @levels;
my @solutions;
my @presses;
my $flag = 0;
my $level = '';
my $vimout = '';
my $solution = '';

foreach (<DATA>) {
    if ($_ =~ "---------- ([0-9]+|X)") {
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
$level = r($levelfile);
$vimout = r($vimfile);

if ($presses[$ID] eq 'X') {
    system($level);
    my $v = eval($solutions[$ID]);
    if ($v) {
        die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($ID)."VIM$presses[$ID]OUT".md5_hex(r($0))) . "\n";
    } else {
        die "Sorry, the command you provided did not produce the correct output. Try again!\n";
    }
}

if (length $vimout > $presses[$ID]) {
    die "Sorry, you have used more key presses than allowed ($presses[$ID]). Try again!\n";
}
if ($solutions[$ID] ne $level) {
    die "Sorry, your output file does not match our correct output file. Try again!\n";
}

die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($level)."VIM$presses[$ID]OUT".md5_hex(r($0))) . "\n";

__END__
Replace this text with a correct command.
---------- X
fe('zoznam.txt', cut('/etc/passwd', 0, ':'))
==========
Replace this text with a correct command.
---------- X
fe('zoznam.txt', cut('/etc/passwd', 6, ':'))
==========
Replace this text with a correct command.
---------- X
fe('zoznam.txt', cut('/etc/passwd', 3, ':'))
==========
the hitchhiker’s guide to the galaxy has a few things to say on the subject of towels.

a towel, it says, is about the most massively useful thing an interstellar hitch hiker can have. partly it has great practical value — you can wrap it around you for warmth as you bound across the cold moons of jaglan beta; you can lie on it on the brilliant marble‐sanded beaches of santraginus v, inhaling the heady sea vapours; you can sleep under it beneath the stars which shine so redly on the desert world of kakrafoon; use it to sail a mini raft down the slow heavy river moth; wet it for use in hand‐to‐hand‐combat; wrap it round your head to ward off noxious fumes or to avoid the gaze of the ravenous bugblatter beast of traal (a mindbogglingly stupid animal, it assumes that if you can't see it, it can't see you — daft as a bush, but very ravenous); you can wave your towel in emergencies as a distress signal, and of course dry yourself off with it if it still seems to be clean enough.
---------- 50
gur uvgpuuvxre’f thvqr gb gur tnynkl unf n srj guvatf gb fnl ba gur fhowrpg bs gbjryf.

n gbjry, vg fnlf, vf nobhg gur zbfg znffviryl hfrshy guvat na vagrefgryyne uvgpu uvxre pna unir. cnegyl vg unf terng cenpgvpny inyhr — lbh pna jenc vg nebhaq lbh sbe jnezgu nf lbh obhaq npebff gur pbyq zbbaf bs wntyna orgn; lbh pna yvr ba vg ba gur oevyyvnag zneoyr‐fnaqrq ornpurf bs fnagentvahf i, vaunyvat gur urnql frn incbhef; lbh pna fyrrc haqre vg orarngu gur fgnef juvpu fuvar fb erqyl ba gur qrfreg jbeyq bs xnxensbba; hfr vg gb fnvy n zvav ensg qbja gur fybj urnil evire zbgu; jrg vg sbe hfr va unaq‐gb‐unaq‐pbzong; jenc vg ebhaq lbhe urnq gb jneq bss abkvbhf shzrf be gb nibvq gur tnmr bs gur enirabhf ohtoynggre ornfg bs genny (n zvaqobttyvatyl fghcvq navzny, vg nffhzrf gung vs lbh pna'g frr vg, vg pna'g frr lbh — qnsg nf n ohfu, ohg irel enirabhf); lbh pna jnir lbhe gbjry va rzretrapvrf nf n qvfgerff fvtany, naq bs pbhefr qel lbhefrys bss jvgu vg vs vg fgvyy frrzf gb or pyrna rabhtu.
==========
gur uvgpuuvxre’f thvqr gb gur tnynkl unf n srj guvatf gb fnl ba gur fhowrpg bs gbjryf.

n gbjry, vg fnlf, vf nobhg gur zbfg znffviryl hfrshy guvat na vagrefgryyne uvgpu uvxre pna unir. cnegyl vg unf terng cenpgvpny inyhr — lbh pna jenc vg nebhaq lbh sbe jnezgu nf lbh obhaq npebff gur pbyq zbbaf bs wntyna orgn; lbh pna yvr ba vg ba gur oevyyvnag zneoyr‐fnaqrq ornpurf bs fnagentvahf i, vaunyvat gur urnql frn incbhef; lbh pna fyrrc haqre vg orarngu gur fgnef juvpu fuvar fb erqyl ba gur qrfreg jbeyq bs xnxensbba; hfr vg gb fnvy n zvav ensg qbja gur fybj urnil evire zbgu; jrg vg sbe hfr va unaq‐gb‐unaq‐pbzong; jenc vg ebhaq lbhe urnq gb jneq bss abkvbhf shzrf be gb nibvq gur tnmr bs gur enirabhf ohtoynggre ornfg bs genny (n zvaqobttyvatyl fghcvq navzny, vg nffhzrf gung vs lbh pna'g frr vg, vg pna'g frr lbh — qnsg nf n ohfu, ohg irel enirabhf); lbh pna jnir lbhe gbjry va rzretrapvrf nf n qvfgerff fvtany, naq bs pbhefr qel lbhefrys bss jvgu vg vs vg fgvyy frrzf gb or pyrna rabhtu.
---------- 50
the hitchhiker’s guide to the galaxy has a few things to say on the subject of towels.

a towel, it says, is about the most massively useful thing an interstellar hitch hiker can have. partly it has great practical value — you can wrap it around you for warmth as you bound across the cold moons of jaglan beta; you can lie on it on the brilliant marble‐sanded beaches of santraginus v, inhaling the heady sea vapours; you can sleep under it beneath the stars which shine so redly on the desert world of kakrafoon; use it to sail a mini raft down the slow heavy river moth; wet it for use in hand‐to‐hand‐combat; wrap it round your head to ward off noxious fumes or to avoid the gaze of the ravenous bugblatter beast of traal (a mindbogglingly stupid animal, it assumes that if you can't see it, it can't see you — daft as a bush, but very ravenous); you can wave your towel in emergencies as a distress signal, and of course dry yourself off with it if it still seems to be clean enough.
==========
"the babel fish," said the hitchhiker's guide to the galaxy quietly, "is small, yellow and leech-like, and probably the oddest thing in the universe. it feeds on brainwave energy received not from its own carrier but from those around it. it absorbs all unconscious mental frequencies from this brainwave energy to nourish itself with. it then excretes into the mind of its carrier a telepathic matrix formed by combining the conscious thought frequencies with nerve signals picked up from the speech centres of the brain which has supplied them. the practical upshot of all this is that if you stick a babel fish in your ear you can instantly understand anything in any form of language. the speech patterns you actually hear decode the brainwave matrix which has been fed into your mind by your babel fish.
---------- 45
"gur onory svfu," fnvq gur uvgpuuvxre'f thvqr gb gur tnynkl dhvrgyl, "vf fznyy, lryybj naq yrrpu-yvxr, naq cebonoyl gur bqqrfg guvat va gur havirefr. vg srrqf ba oenvajnir raretl erprvirq abg sebz vgf bja pneevre ohg sebz gubfr nebhaq vg. vg nofbeof nyy hapbafpvbhf zragny serdhrapvrf sebz guvf oenvajnir raretl gb abhevfu vgfrys jvgu. vg gura rkpergrf vagb gur zvaq bs vgf pneevre n gryrcnguvp zngevk sbezrq ol pbzovavat gur pbafpvbhf gubhtug serdhrapvrf jvgu areir fvtanyf cvpxrq hc sebz gur fcrrpu pragerf bs gur oenva juvpu unf fhccyvrq gurz. gur cenpgvpny hcfubg bs nyy guvf vf gung vs lbh fgvpx n onory svfu va lbhe rne lbh pna vafgnagyl haqrefgnaq nalguvat va nal sbez bs ynathntr. gur fcrrpu cnggreaf lbh npghnyyl urne qrpbqr gur oenvajnir zngevk juvpu unf orra srq vagb lbhe zvaq ol lbhe onory svfu.
==========
"gur onory svfu," fnvq gur uvgpuuvxre'f thvqr gb gur tnynkl dhvrgyl, "vf fznyy, lryybj naq yrrpu-yvxr, naq cebonoyl gur bqqrfg guvat va gur havirefr. vg srrqf ba oenvajnir raretl erprvirq abg sebz vgf bja pneevre ohg sebz gubfr nebhaq vg. vg nofbeof nyy hapbafpvbhf zragny serdhrapvrf sebz guvf oenvajnir raretl gb abhevfu vgfrys jvgu. vg gura rkpergrf vagb gur zvaq bs vgf pneevre n gryrcnguvp zngevk sbezrq ol pbzovavat gur pbafpvbhf gubhtug serdhrapvrf jvgu areir fvtanyf cvpxrq hc sebz gur fcrrpu pragerf bs gur oenva juvpu unf fhccyvrq gurz. gur cenpgvpny hcfubg bs nyy guvf vf gung vs lbh fgvpx n onory svfu va lbhe rne lbh pna vafgnagyl haqrefgnaq nalguvat va nal sbez bs ynathntr. gur fcrrpu cnggreaf lbh npghnyyl urne qrpbqr gur oenvajnir zngevk juvpu unf orra srq vagb lbhe zvaq ol lbhe onory svfu.
---------- 50
"the babel fish," said the hitchhiker's guide to the galaxy quietly, "is small, yellow and leech-like, and probably the oddest thing in the universe. it feeds on brainwave energy received not from its own carrier but from those around it. it absorbs all unconscious mental frequencies from this brainwave energy to nourish itself with. it then excretes into the mind of its carrier a telepathic matrix formed by combining the conscious thought frequencies with nerve signals picked up from the speech centres of the brain which has supplied them. the practical upshot of all this is that if you stick a babel fish in your ear you can instantly understand anything in any form of language. the speech patterns you actually hear decode the brainwave matrix which has been fed into your mind by your babel fish.
==========
/bin/bash
/bin/false
/bin/false
/bin/false
/bin/false
/bin/false
/sbin/nologin
/sbin/nologin
/bin/false
/bin/bash
/bin/bash
/bin/false
/bin/false
/bin/bash
/bin/false
/bin/false
/bin/false
/bin/bash
/sbin/nologin
/bin/false
/bin/bash
---------- 40
      6 /bin/bash
     12 /bin/false
      3 /sbin/nologin
==========
/bin/bash
/bin/false
/bin/false
/bin/false
/bin/false
/bin/false
/sbin/nologin
/sbin/nologin
/bin/false
/bin/bash
/bin/bash
/bin/false
/bin/false
/bin/bash
/bin/false
/bin/false
/bin/false
/bin/bash
/sbin/nologin
/bin/false
/bin/bash
---------- 40
/bin/bash
/bin/false
/sbin/nologin
==========
