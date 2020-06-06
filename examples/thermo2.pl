# Puzzle by Ashish Kumar:
#
# https://www.gmpuzzles.com/blog/2019/09/thermo-sudoku-by-ashish-kumar-2/
#
# Used here under CC BY-NC-ND 3.0

puzzle_facts <<"HERE";
___ ___ ___
___ ___ ___
___ ___ ___

___ ___ ___
___ ___ ___
___ ___ ___

___ ___ ___
___ ___ ___
___ ___ ___
HERE

thermo qw(5,1 4,1);
thermo qw(1,3 2,3);
thermo qw(7,2 7,1 8,1 9,1);
thermo qw(7,2 7,3 8,3 9,3);
thermo qw(2,5 2,4 3,4 3,3 4,3 4,2 5,2);
thermo qw(1,5 1,4);
thermo qw(5,5 6,5 6,4 5,4 4,4 4,5 4,6);
thermo qw(9,5 9,6);
thermo qw(8,5 8,6 7,6 7,7 6,7 6,8 5,8);
thermo qw(1,9 1,8 1,7);
thermo qw(1,9 2,8 3,9 3,8 3,7);
thermo qw(5,9 6,9);
thermo qw(9,7 8,7);
