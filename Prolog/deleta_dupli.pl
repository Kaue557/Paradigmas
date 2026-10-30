% GPT VERSION
deldup([], []).
deldup([A|X], [A|Y]):-
    deldup(X, Y),
    not(member(A, Y)).
deldup([A|X], Y):-
    deldup(X, Y),
    member(A, Y).
