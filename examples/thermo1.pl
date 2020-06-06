puzzle_facts <<"HERE";
169 325 847
384 671 5__
275 948 631

428 159 763
653 784 1__
791 236 485

536 812 974
812 497 356
947 563 218
HERE

# Try commenting this line out and running it. You should get two
# solutions, with 9's and 2's interchanged. This line specifies that
# 8,5 must be less than 9,5, which invalidates one of the two
# solutions.
thermo qw(8,5 9,5);
