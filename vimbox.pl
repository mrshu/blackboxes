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
$level = r($levelfile);
$vimout = r($vimfile);

if (length $vimout > $presses[$ID]) {
    die "Sorry, you have used more key presses than allowed ($presses[$ID]). Try again!\n";
}
if ($solutions[$ID] ne $level) {
    die "Sorry, your output file does not match our correct output file. Try again!\n";
}

die "Congratulations! The password is: " . md5_hex($ENV{USER}.md5_hex($level)."VIM$presses[$ID]OUT") . "\n";

__END__
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
---------- 15
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
==========
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
---------- 15
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
==========
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
---------- 15
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.
==========
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the Stevie editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.

Although Vim was originally released for the Amiga, Vim has since been developed to be cross-platform, supporting many other platforms. In 2006, it was voted the most popular editor amongst Linux Journal readers.

# History

Bram Moolenaar began working on Vim for the Amiga computer in 1988. Moolenaar first publicly released Vim (v1.14) in 1991. Vim was based on an earlier editor, Stevie, for the Atari ST, created by Tim Thompson, Tony Andrews and G.R. (Fred) Walter.

The name "Vim" is an acronym for "Vi IMproved" because Vim is an extended version of the vi editor, with many additional features designed to be helpful in editing program source code. Originally, the acronym stood for "Vi IMitation", but that was changed with the release of Vim 2.0 in December 1993. A later comment states that the reason for changing the name was that Vim's feature set surpassed that of vi.

# Interface

Like vi, Vim's interface is not based on menus or icons but on commands given in a text user interface; its GUI mode, gVim, adds menus and toolbars for commonly used commands but the full functionality is still expressed through its command line mode. Vi (and by extension Vim) tends to allow a typist to keep their fingers on the home row, which can be an advantage for a touch typist.

Vim has a built-in tutorial for beginners (accessible through the "vimtutor" command). There is also the Vim Users' Manual that details Vim's features. This manual can be read from within Vim, or found online.

Vim also has a built-in help facility (using the :help command) that allows users to query and navigate through commands and features.

# Customization

Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions.

There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl.

There are projects bundling together complex scripts and customizations and aimed at turning Vim into a tool for a specific task or adding a major flavour to its behaviour. Examples include Cream, which makes Vim behave like a click-and-type editor, or VimOutliner, which provides a comfortable outliner for users of Unix-like systems.
---------- 30
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the Stevie editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.

Although Vim was originally released for the Amiga, Vim has since been developed to be cross-platform, supporting many other platforms. In 2006, it was voted the most popular editor amongst Linux Journal readers.

# History

Bram Moolenaar began working on Vim for the Amiga computer in 1988. Moolenaar first publicly released Vim (v1.14) in 1991. Vim was based on an earlier editor, Stevie, for the Atari ST, created by Tim Thompson, Tony Andrews and G.R. (Fred) Walter.

The name "Vim" is an acronym for "Vi IMproved" because Vim is an extended version of the vi editor, with many additional features designed to be helpful in editing program source code. Originally, the acronym stood for "Vi IMitation", but that was changed with the release of Vim 2.0 in December 1993. A later comment states that the reason for changing the name was that Vim's feature set surpassed that of vi. (well, sort of)

# Interface

Like vi, Vim's interface is not based on menus or icons but on commands given in a text user interface; its GUI mode, gVim, adds menus and toolbars for commonly used commands but the full functionality is still expressed through its command line mode. Vi (and by extension Vim) tends to allow a typist to keep their fingers on the home row, which can be an advantage for a touch typist.

Vim has a built-in tutorial for beginners (accessible through the "vimtutor" command). There is also the Vim Users' Manual that details Vim's features. This manual can be read from within Vim, or found online.

Vim also has a built-in help facility (using the :help command) that allows users to query and navigate through commands and features.

# Customization

Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions.

There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl.

There are projects bundling together complex scripts and customizations and aimed at turning Vim into a tool for a specific task or adding a major flavour to its behaviour. Examples include Cream, which makes Vim behave like a click-and-type editor, or VimOutliner, which provides a comfortable outliner for users of Unix-like systems.
==========
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the Stevie editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.

Although Vim was originally released for the Amiga, Vim has since been developed to be cross-platform, supporting many other platforms. In 2006, it was voted the most popular editor amongst Linux Journal readers.

# History

Bram Moolenaar began working on Vim for the Amiga computer in 1988. Moolenaar first publicly released Vim (v1.14) in 1991. Vim was based on an earlier editor, Stevie, for the Atari ST, created by Tim Thompson, Tony Andrews and G.R. (Fred) Walter.

The name "Vim" is an acronym for "Vi IMproved" because Vim is an extended version of the vi editor, with many additional features designed to be helpful in editing program source code. Originally, the acronym stood for "Vi IMitation", but that was changed with the release of Vim 2.0 in December 1993. A later comment states that the reason for changing the name was that Vim's feature set surpassed that of vi.

# Interface

Like vi, Vim's interface is not based on menus or icons but on commands given in a text user interface; its GUI mode, gVim, adds menus and toolbars for commonly used commands but the full functionality is still expressed through its command line mode. Vi (and by extension Vim) tends to allow a typist to keep their fingers on the home row, which can be an advantage for a touch typist.

Vim has a built-in tutorial for beginners (accessible through the "vimtutor" command). There is also the Vim Users' Manual that details Vim's features. This manual can be read from within Vim, or found online.

Vim also has a built-in help facility (using the :help command) that allows users to query and navigate through commands and features.

# Customization

Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions.

There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl.

There are projects bundling together complex scripts and customizations and aimed at turning Vim into a tool for a specific task or adding a major flavour to its behaviour. Examples include Cream, which makes Vim behave like a click-and-type editor, or VimOutliner, which provides a comfortable outliner for users of Unix-like systems.
---------- 35
Vim (/vɪm/; a contraction of Vi IMproved) is a clone of Bill Joy's vi editor for Unix. It was written by Bram Moolenaar based on source for a port of the Stevie editor to the Amiga and first released publicly in 1991. Vim is designed for use both from a command-line interface and as a standalone application in a graphical user interface. Vim is free and open source software and is released under a license that includes some charityware clauses, encouraging users who enjoy the software to consider donating to children in Uganda. The license is compatible with the GNU General Public License.

Although Vim was originally released for the Amiga, Vim has since been developed to be cross-platform, supporting many other platforms. In 2006, it was voted the most popular editor amongst Linux Journal readers.

# History

Bram Moolenaar began working on Vim for the Amiga computer in 1988. Moolenaar first publicly released Vim (v1.14) in 1991. Vim was based on an earlier editor, Stevie, for the Atari ST, created by Tim Thompson, Tony Andrews and G.R. (Fred) Walter.

The name "Vim" is an acronym for "Vi IMproved" because Vim is an extended version of the vi editor, with many additional features designed to be helpful in editing program source code. Originally, the acronym stood for "Vi IMitation", but that was changed with the release of Vim 2.0 in December 1993. A later comment states that the reason for changing the name was that Vim's feature set surpassed that of vi.

# Interface

Like vi, Vim's interface is not based on menus or icons but on commands given in a text user interface; its GUI mode, gVim, adds menus and toolbars for commonly used commands but the full functionality is still expressed through its command line mode. Vi (and by extension Vim) tends to allow a typist to keep their fingers on the home row, which can be an advantage for a touch typist.

Vim has a built-in tutorial for beginners (accessible through the "vimtutor" command). There is also the Vim Users' Manual that details Vim's features. This manual can be read from within Vim, or found online.

Vim also has a built-in help facility (using the :help command) that allows users to query and navigate through commands and features.

# Customization

Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions.

There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl. (and many others)

There are projects bundling together complex scripts and customizations and aimed at turning Vim into a tool for a specific task or adding a major flavour to its behaviour. Examples include Cream, which makes Vim behave like a click-and-type editor, or VimOutliner, which provides a comfortable outliner for users of Unix-like systems.
==========
Bash is a Unix shell written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell. Released in 1989, it has been distributed widely as the shell for the GNU operating system and as a default shell on Linux and OS X. It has been ported to Microsoft Windows and distributed with Cygwin and MinGW, to DOS by the DJGPP project, to Novell NetWare and to Android via various terminal emulation applications. In the late 1990s, Bash was a minor player among multiple commonly used shells; at present Bash has overwhelming favor.
---------- 50
126
==========
Bash is a Unix shell written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell. Released in 1989, it has been distributed widely as the shell for the GNU operating system and as a default shell on Linux and OS X. It has been ported to Microsoft Windows and distributed with Cygwin and MinGW, to DOS by the DJGPP project, to Novell NetWare and to Android via various terminal emulation applications. In the late 1990s, Bash was a minor player among multiple commonly used shells; at present Bash has overwhelming favor.
---------- 50
151
==========
Bash is a Unix shell written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell. Released in 1989, it has been distributed widely as the shell for the GNU operating system and as a default shell on Linux and OS X. It has been ported to Microsoft Windows and distributed with Cygwin and MinGW, to DOS by the DJGPP project, to Novell NetWare and to Android via various terminal emulation applications. In the late 1990s, Bash was a minor player among multiple commonly used shells; at present Bash has overwhelming favor.
---------- 50
123
==========
Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions. There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl. 
---------- 50
224
==========
Part of Vim's power is that it can be extensively customized. The basic interface can be controlled by the many options available, and the user can define personalized key mappings—often called macros—or abbreviations to automate sequences of keystrokes, or even call internal or user defined functions. There are many plugins available that will extend or add new functionality to Vim. These complex scripts are usually written in Vim's internal scripting language vimscript. Vim also supports scripting using Lua (as of Vim 7.3), Perl, Python, Racket (formerly PLT Scheme), Ruby, and Tcl. 
---------- 50
214
==========
Moist von Lipwig | 10.14
Reacher Gilt | 15.34
Patrician Havelock Vetinari | 6.73
Adora Belle Dearheart | 13
Mr Pump | 7.3
Mr Spools | 17.89
Drumknott | 20.30
Tolliver Groat | 14.56
Miss Cripslock | 8.92
Angua | 20.1
Mr Gryle | 53.42
Stanley Howler | 25.67
Horsefry | 0.43
Postman | 1.58
---------- 100
1. ucastnik: Horsefry | 0.43
2. ucastnik: Postman | 1.58
3. ucastnik: Patrician Havelock Vetinari | 6.73
4. ucastnik: Mr Pump | 7.3
5. ucastnik: Miss Cripslock | 8.92
6. ucastnik: Moist von Lipwig | 10.14
7. ucastnik: Adora Belle Dearheart | 13
8. ucastnik: Tolliver Groat | 14.56
9. ucastnik: Reacher Gilt | 15.34
10. ucastnik: Mr Spools | 17.89
11. ucastnik: Angua | 20.1
12. ucastnik: Drumknott | 20.30
13. ucastnik: Stanley Howler | 25.67
14. ucastnik: Mr Gryle | 53.42
==========
Moist von Lipwig | 10.14
Reacher Gilt | 15.34
Patrician Havelock Vetinari | 6.73

Adora Belle Dearheart | 13
Mr Pump | 7.3
Mr Spools | 17.89
Drumknott | 20.30
Tolliver Groat | 14.56

Miss Cripslock | 8.92
Angua | 20.1

Mr Gryle | 53.42

Stanley Howler | 25.67
Horsefry | 0.43

Postman | 1.58
---------- 90
1. Horsefry | 0.43
2. Postman | 1.58
3. Patrician Havelock Vetinari | 6.73
4. Mr Pump | 7.3
5. Miss Cripslock | 8.92
6. Moist von Lipwig | 10.14
7. Adora Belle Dearheart | 13
8. Tolliver Groat | 14.56
9. Reacher Gilt | 15.34
10. Mr Spools | 17.89
11. Angua | 20.1
12. Drumknott | 20.30
13. Stanley Howler | 25.67
14. Mr Gryle | 53.42
==========
