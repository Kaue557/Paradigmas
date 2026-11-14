% QUICK SORT

qs([],[]).
qs([A],[A]).
qs([P|L],R) :-
    partit(P,L,Lmen,Lmai),
    qs(Lmen,Rmen),
    qs(Lmai,Rmai),
    append(Rmen,[P|Rmai],R).

partit(_,[],[],[]). % "independente do pivô, se a lista 1 e lista 2 forem vazias, o resultado é uma lista vazia(?)"
partit(P,[A|As],[A|Lmen],Lmai) :-
    A =< P,
    partit(P,As,Lmen,Lmai).

partit(P,[A|As],Lmen,[A|Lmai]) :-
    partit(P,As,Lmen,Lmai).