% BUBBLE SORT

bubble([],[]). /*se lista vazia*/
bubble(L,R) :-
    bubble(L,L,R).
    /*predicado diferente do de cima, é uma lista que diz quantas vezes usaremos o levmai sobre a lista(?)*/

bubble([],Lac,Lac).
bubble([_|X],Lac,R) :-
    levmai(Lac,Lac2),
    bubble(X,Lac2,R).

levmai([],[]). /*se lista vazia*/
levmai([A],[A]). /*se so tem um elemento*/
levmai([A,B|X],[B|Y]) :-
    B < A,
    levmai([A|X],Y).
levmai([A|X],[A|Y]) :-
    levmai(X,Y).