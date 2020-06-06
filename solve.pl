#!/usr/bin/env perl

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

### THESE FUNCTIONS ARE MEANT TO BE CALLED WITHIN SCRIPT FILES ###

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

# thermo(@chain)
sub thermo {
    my @chain = @_;
    for my $i (0..(@chain-2)) {
        my $pos1 = $chain[$i];
        my $pos2 = $chain[$i + 1];
        say ":- pos(c($pos1), U), pos(c($pos2), V), V <= U.";
    }
}

# partial_info($pos, @args)
sub partial_info {
    local $" = ', ';
    my $pos = shift;
    my @args = @_;
    say qq(@{[map { "V = $_" } @args]} :- pos(c($pos), V).);
}

### END SCRIPT API ###

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

{
    no warnings 'qw';
    select $tmpfh;
    eval $code;
    die $@ if $@;
    select STDOUT;
}

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

END {
    `rm $tmpfile`; # Perl doesn't seem to want to do this itself. :(
}
