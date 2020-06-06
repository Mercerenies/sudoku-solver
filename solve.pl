#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use autodie;

use File::Temp qw(tempfile cleanup);
use File::Basename qw(dirname);
use Config;
use IO::Handle;

# process_output($line)
sub process_output {
    my $line = shift;
    my %result;
    while ($line =~ m[ pos\( c\( (\d+), (\d+) \), (\d+) \)]gx) {
        $result{"$1,$2"} = $3;
    }
    \%result;
}

# print_puzzle($puzzle)
sub print_puzzle {
    my $puzzle = shift;
    for my $y (1..9) {
        for my $x (1..9) {
            print $puzzle->{"$x,$y"};
            print " " if $x % 3 == 0;
        }
        print "\n";
        print "\n" if $y % 3 == 0;
    }
}

# parse_puzzle($fh)
sub parse_puzzle {
    my $fh = shift;
    my %result;
    for my $y (1..9) {
        my $line = <$fh>;
        redo if $line =~ /^$/;
        my $x = 1;
        while ($line =~ /\d|_/g) {
            $result{"$x,$y"} = $&;
            last if ++$x > 9;
        }
    }
    \%result;
}

# puzzle_facts($string)
sub puzzle_facts {
    my $string = shift;
    open(my $fh, '<', \$string);
    my $puzzle = parse_puzzle($fh);
    close($fh);
    for my $key (keys %$puzzle) {
        $key =~ /(\d+),(\d+)/;
        my $value = $puzzle->{$key};
        if ($value ne '_') {
            say "pos(c($1, $2), $value).";
        }
    }
}

my $path = dirname $0;

if ((@ARGV < 1) || ($ARGV[0] =~ /--help|-help/)) {
    die("Usage: ./solve.pl <filename>");
}

my ($tmpfh, $tmpfile) = tempfile('sudokuXXXX', SUFFIX => '.txt', CLEANUP => 1);

open(my $staticfh, '<', 'sudoku.lp');
while (<$staticfh>) {
    print $tmpfh $_;
};

open(my $infh, '<', $ARGV[0]);
my $code;
$code .= $_ while <$infh>;
close($infh);

select $tmpfh;
eval $code;
select STDOUT;

$tmpfh->flush();

open(my $outfh, '-|', "clingo $tmpfile 0");
while (<$outfh>) {
    if (/^Answer: \d+/) {
        print;
        my $next = <$outfh>;
        my %result = %{process_output($next)};
        print_puzzle \%result;
    } else {
        print;
    }
}

close($tmpfh);
cleanup();

`rm $tmpfile`; # Perl doesn't seem to want to do this itself. :(