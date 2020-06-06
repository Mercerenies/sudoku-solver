#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

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

while (<>) {
    if (/^Answer: \d+/) {
        print;
        my $next = <>;
        my %result = %{process_output($next)};
        print_puzzle \%result;
    } else {
        print;
    }
}
