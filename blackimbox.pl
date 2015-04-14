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

sub u {
    my $s = shift;
    $s =~ tr/!-~/P-~!-O/;
    return $s;
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
    if ($_ =~ "---------- ([0-9]+|X|B)") {
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

if ($presses[$ID] eq 'B') {
    t();
}

c($levelfile, $levels[$ID]);
system("vim -N --cmd 'set ". join(' ', @config) ."' -u NONE -w $vimfile $levelfile");
$level = r($levelfile);
$vimout = r($vimfile);

if ($presses[$ID] eq 'B') {
    my $sol = u($solutions[$ID]);
    if (`$sol` eq `$level`) {
        die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($ID)."VIM$presses[$ID]OUT".md5_hex(r($0))) . "\n";
    } else {
        die "Sorry, the command you provided did not produce the correct output. Try again!\n";
    }
}

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
Replace this text with a correct command.
---------- B
649@ VQE96 3236= 7:D9[Q D2:5 E96 9:E499:<6CD 8F:56 E@ E96 82=2IJ BF:6E=J[ Q:D D>2==[ J6==@H 2?5 =6649\=:<6[ 2?5 AC@323=J E96 @556DE E9:?8 :? E96 F?:G6CD6] :E 7665D @? 3C2:?H2G6 6?6C8J C646:G65 ?@E 7C@> :ED @H? 42CC:6C 3FE 7C@> E9@D6 2C@F?5 :E] :E 23D@C3D 2== F?4@?D4:@FD >6?E2= 7C6BF6?4:6D 7C@> E9:D 3C2:?H2G6 6?6C8J E@ ?@FC:D9 :ED6=7 H:E9] :E E96? 6I4C6E6D :?E@ E96 >:?5 @7 :ED 42CC:6C 2 E6=6A2E9:4 >2EC:I 7@C>65 3J 4@>3:?:?8 E96 4@?D4:@FD E9@F89E 7C6BF6?4:6D H:E9 ?6CG6 D:8?2=D A:4<65 FA 7C@> E96 DA6649 46?EC6D @7 E96 3C2:? H9:49 92D DFAA=:65 E96>] E96 AC24E:42= FAD9@E @7 2== E9:D :D E92E :7 J@F DE:4< 2 3236= 7:D9 :? J@FC 62C J@F 42? :?DE2?E=J F?56CDE2?5 2?JE9:?8 :? 2?J 7@C> @7 =2?8F286] E96 DA6649 A2EE6C?D J@F 24EF2==J 962C 564@56 E96 3C2:?H2G6 >2EC:I H9:49 92D 366? 765 :?E@ J@FC >:?5 3J J@FC 3236= 7:D9]Vm^56G^?F==j7:?5 ] \?2>6 QY]J2Q \D:K6 b4j649@ VQ8FC @?@CJ DG7F[Q 7?GB 8FC FG8AFFGIC67 E9GBC 83 8FC E?J?<= 59GC8J=[ QG7 7K?JJ[ =CJJ3; ?2B JCCAF\JGIC[ ?2B 463@?@J= 8FC 3BBC78 8FG2E G2 8FC 92G:C67C] G8 DCCB7 32 @6?G2;?:C C2C6E= 6CACG:CB 238 D63K G87 3;2 A?66GC6 @98 D63K 8F37C ?6392B G8] G8 ?@736@7 ?JJ 92A327AG397 KC28?J D6C59C2AGC7 D63K 8FG7 @6?G2;?:C C2C6E= 83 2396G7F G87CJD ;G8F] G8 8FC2 C<A6C8C7 G283 8FC KG2B 3D G87 A?66GC6 ? 8CJC4?8FGA K?86G< D36KCB @= A3K@G2G2E 8FC A327AG397 8F39EF8 D6C59C2AGC7 ;G8F 2C6:C 7GE2?J7 4GAICB 94 D63K 8FC 74CCAF AC286C7 3D 8FC @6?G2 ;FGAF F?7 7944JGCB 8FCK] 8FC 46?A8GA?J 947F38 3D ?JJ 8FG7 G7 8F?8 GD =39 78GAI ? @?@CJ DG7F G2 =396 C?6 =39 A?2 G278?28J= 92BC678?2B ?2=8FG2E G2 ?2= D36K 3D J?2E9?EC] 8FC 74CCAF 4?88C627 =39 ?A89?JJ= FC?6 BCA3BC 8FC @6?G2;?:C K?86G< ;FGAF F?7 @CC2 DCB G283 =396 KG2B @= =396 @?@CJ DG7F]Vm^56G^?F==j
==========
Replace this text with a correct command.
---------- B
649@ VQ8FC @?@CJ DG7F[Q 7?GB 8FC FG8AFFGIC67 E9GBC 83 8FC E?J?<= 59GC8J=[ QG7 7K?JJ[ =CJJ3; ?2B JCCAF\JGIC[ ?2B 463@?@J= 8FC 3BBC78 8FG2E G2 8FC 92G:C67C] G8 DCCB7 32 @6?G2;?:C C2C6E= 6CACG:CB 238 D63K G87 3;2 A?66GC6 @98 D63K 8F37C ?6392B G8] G8 ?@736@7 ?JJ 92A327AG397 KC28?J D6C59C2AGC7 D63K 8FG7 @6?G2;?:C C2C6E= 83 2396G7F G87CJD ;G8F] G8 8FC2 C<A6C8C7 G283 8FC KG2B 3D G87 A?66GC6 ? 8CJC4?8FGA K?86G< D36KCB @= A3K@G2G2E 8FC A327AG397 8F39EF8 D6C59C2AGC7 ;G8F 2C6:C 7GE2?J7 4GAICB 94 D63K 8FC 74CCAF AC286C7 3D 8FC @6?G2 ;FGAF F?7 7944JGCB 8FCK] 8FC 46?A8GA?J 947F38 3D ?JJ 8FG7 G7 8F?8 GD =39 78GAI ? @?@CJ DG7F G2 =396 C?6 =39 A?2 G278?28J= 92BC678?2B ?2=8FG2E G2 ?2= D36K 3D J?2E9?EC] 8FC 74CCAF 4?88C627 =39 ?A89?JJ= FC?6 BCA3BC 8FC @6?G2;?:C K?86G< ;FGAF F?7 @CC2 DCB G283 =396 KG2B @= =396 @?@CJ DG7F]Vm^56G^?F==j7:?5 ] \D:K6 d4 \?2>6 QY]32Qj649@ VQE96 3236= 7:D9[Q D2:5 E96 9:E499:<6CD 8F:56 E@ E96 82=2IJ BF:6E=J[ Q:D D>2==[ J6==@H 2?5 =6649\=:<6[ 2?5 AC@323=J E96 @556DE E9:?8 :? E96 F?:G6CD6] :E 7665D @? 3C2:?H2G6 6?6C8J C646:G65 ?@E 7C@> :ED @H? 42CC:6C 3FE 7C@> E9@D6 2C@F?5 :E] :E 23D@C3D 2== F?4@?D4:@FD >6?E2= 7C6BF6?4:6D 7C@> E9:D 3C2:?H2G6 6?6C8J E@ ?@FC:D9 :ED6=7 H:E9] :E E96? 6I4C6E6D :?E@ E96 >:?5 @7 :ED 42CC:6C 2 E6=6A2E9:4 >2EC:I 7@C>65 3J 4@>3:?:?8 E96 4@?D4:@FD E9@F89E 7C6BF6?4:6D H:E9 ?6CG6 D:8?2=D A:4<65 FA 7C@> E96 DA6649 46?EC6D @7 E96 3C2:? H9:49 92D DFAA=:65 E96>] E96 AC24E:42= FAD9@E @7 2== E9:D :D E92E :7 J@F DE:4< 2 3236= 7:D9 :? J@FC 62C J@F 42? :?DE2?E=J F?56CDE2?5 2?JE9:?8 :? 2?J 7@C> @7 =2?8F286] E96 DA6649 A2EE6C?D J@F 24EF2==J 962C 564@56 E96 3C2:?H2G6 >2EC:I H9:49 92D 366? 765 :?E@ J@FC >:?5 3J J@FC 3236= 7:D9]Vm^56G^?F==j
==========
