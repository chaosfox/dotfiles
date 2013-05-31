#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;
use Getopt::Long;
use Cwd qw(abs_path);
use File::Basename;

#
# yet another dotfiles bootstrapper(TM) perl edition
#
# all the file => link mappings are in the bootstrap.conf file
# without arguments, the script will just check what can be done,
# with the --exec flag it will actually create 
# links for files that are 'linkable'
# everything done in full ANSI color because why not
#

require 'bootstrap.conf';
our ($src_dir, $dst_dir, $index);

my $exec = 0;
GetOptions(
	"exec" => \$exec # actually make the links
); 

while(my ($s, $d) = each %$index) {

	# makes files relative to the src and dst dir's
	# expand shell variables like $HOME
	($s) = glob($src_dir.$s); 
	($d) = glob($dst_dir.$d);

	my $txt = RESET. (BOLD "[$s]")." to ".BOLD "[$d]";
	$txt =~ s/$ENV{HOME}/~/g;

	# source file not found
	unless(-e $s) {
		print RED sprintf("%26s","Source doesn't exist. "), $txt, "\n";
		next;
	}
	# destination file exists
	if(-e $d) {
		if(abs_path($d) eq abs_path($s)) { # its already linked or its the same file
			print CYAN sprintf("%26s","Link already exists. "), $txt, "\n";
			next;
		}
		else {
			print YELLOW sprintf("%26s","Dest. exists. "), $txt, "\n";
			next;
		}
	}

	my ($filename, $path) = fileparse($d);
	# destination path does not exist
	unless(-e $path) {
		print YELLOW sprintf("%26s","Dest. path doesn't exist. "), $txt, "\n";
		next;
	}

	if($exec) {
		if(symlink $s, $d) {
			print GREEN sprintf("%26s","Link created. "), $txt, "\n";
		}
		else {
			print RED "Link Error: $!. ", $txt, "\n";
		}
	} else {
		print GREEN sprintf("%26s","Linkable. "), $txt, "\n";
	}
}

