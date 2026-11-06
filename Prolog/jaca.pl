% RLD

% COM ACUMULADOR (mais fácil)
rptac(C,N,R) :- rptac(C,N,[],R).
rptac(_,0,Lac,Lac).
rptac(C,N,Lac,R) :- N2 is N-1, rptac(C,N2,[C|Lac],R).

% RECURSIVO PURO
rpt(_,0,[]).
rpt(C,N,[C|X]) :- N2 is N-1, rpt(C, N2,X).