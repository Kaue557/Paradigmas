% BUBBLE SORT

bubble(L,R) :- bubble(L,L,R).

bubble([_|X],Lac,Lac),
bubble([_,X],Lac,R) :- le % FINALIZAR (NÃO TEM FOTO)

levemai([A],[A]).
levemai([E,A|X],[A|Y]) :-
    E > A,
    levemai([E|X],Y).
% SE 'E' NÃO FOR MAIOR QUE 'A'
levemai([A|X],[A,Y]) :-
    levemai(X,Y).
