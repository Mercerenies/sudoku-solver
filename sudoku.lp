
xcoord(1..9).
ycoord(1..9).
value(1..9).

box(b(1..3, 1..3)).

in_box(c(X, Y), b(BX, BY)) :-
    box(b(BX, BY)),
    coord(c(X, Y)),
    S = 0..2,
    T = 0..2,
    X = BX * 3 - S,
    Y = BY * 3 - T.

coord(c(X, Y)) :- xcoord(X), ycoord(Y).

pos(C, V) :- coord(C), value(V), not not pos(C, V).

:- pos(C, V), pos(C, V'), V != V'.

{ pos(c(X, Y), V) : ycoord(Y) } = 1 :- xcoord(X), value(V).
{ pos(c(X, Y), V) : xcoord(X) } = 1 :- ycoord(Y), value(V).
{ pos(C, V) : in_box(C, B) } = 1 :- box(B), value(V).

#show pos/2.
