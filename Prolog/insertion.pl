% INSERTION SORT
isort(L,R) :- isort(L,[],R).
isort([],Lac,Lac).
isort([A|X],Lac,R) :- insere(A,Lac, Lx). isort(X,Lx,R).

insere(E,[],[E]).
insere(E,[A|X],[E,A|X]) :- E =< A.
insere(E,[A|X],[A|Y]) :- insere(E,X,Y).

% TESTAR SE TROCAR A ORDEM DAS ULTIMAS LINHAS MUDA ALGO