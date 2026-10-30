% _: representa o primeiro elemento da lista, mas seu valor é ignorado.
% X: representa o restante da lista.
% M: representa o menor valor encontrado até o momento.
% R: representa o menor valor final.

menor([A|L], R):-
    menor(L,A,R). % A = menor atual(?)
    menor([], M, M).
menor([A|X], M, R):-
    A < M,
    menor(X, A, R).
menor([_|X], M, R):-
    menor(X, M, R).