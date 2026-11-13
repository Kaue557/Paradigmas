% MERGE SORT
ms([],[]).
ms([A],[A]).
ms(L,R) :-
    split(L,L1,L2).
    ms(L1,R1).
    ms(L2,R2).
    inter(R1,R2,R).

inter([],L,L).
inter(L,[],L).
inter([A|As],[B|Bs],[A|X]) :- A =< B, inter(As,[B|Bs],X).
inter([A|As],[B|Bs],[A|X]) :- inter([A|As],Bs,X).

split([],[],[]).
split([A],[A],[]).
split([A,B|X],[A|As],[B|Bs]) :- split(X,As,Bs).

