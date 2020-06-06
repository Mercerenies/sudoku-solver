
A Sudoku puzzle solver, backed by [Potassco](https://potassco.org/).
You'll need `clingo` (available at the Potassco website) and Perl
(5.010 or newer) on your path to be able to run this.

To run, use

    ./solve.pl <input_file.pl>

(Windows users may have to do `perl ./solve.pl <input_file.pl>`)

The input file should be a Perl script to generate the necessary
Potassco information. For a standard Sudoku puzzle (no special rules),
the following template will suffice.

    puzzle_facts <<'HERE';
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

where any known information should be filled in in the appropriate
blanks. The solver will find every solution to the Sudoku rules you
specify.

Additional variation rules may be specified below the `puzzle_facts`
directive. See `./examples/partial1.pl` for an example of supplying
partial information (e.g., "this cell is not a 9"). Also, check out
`./examples/thermo1.pl` and `./examples/thermo2.pl` to see how to
specify
[Thermo-Sudoku](https://www.gmpuzzles.com/blog/sudoku-rules-and-info/thermo-sudoku-rules-and-info/)
thermometers.

NOTE: The input file you specify is run as a full Perl script, with no
sandbox. It should be regarded as code. DO NOT run input files you
found on the Internet unless you trust the source or have inspected it
yourself.

# How it Works

I'll document this better later. But basically, the input file you
specify is a full Perl script. Its standard output stream is
redirected into a Potassco input file, along with the contents of
[`sudoku.lp`](sudoku.lp). The rest is just constraint solving,
implemented by Potassco. `sudoku.lp` specifies the basic rules of
Sudoku. There are several helper functions provided to your Perl
script to make common rules easier.

Note that whenever these functions need a coordinate, they take a
string of the form `X,Y`, where `X` and `Y` are digits from `1` to
`9`. Also note, for those of you who don't know Perl, that in the
example files I make heavy use of the quoted-word syntax in Perl,
where e.g. `qw(foo bar baz)` is a list containing the strings `"foo"`,
`"bar"`, and `"baz"`.

## `puzzle_facts($string)`

Given a Sudoku puzzle string (using the format exemplified above),
print rules specifying the known positions of the grid. Generally,
you'll call this once at the top of your input file. Calling this with
a grid full of `_` is a no-op.

## `thermo(@positions...)`

Takes any number of arguments, each of which is a coordinate in a
thermometer, starting with the bulb at the first argument. Calling
this with fewer than two arguments is a no-op.

## `partial_info($pos, @args...)`

The first argument specifies a coordinate. The remaining arguments
specify all possible values for that coordinate cell in the grid.
