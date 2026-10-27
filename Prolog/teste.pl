% FATOS
gerou(kelly, maria).
gerou(cleber, maria).
gerou(cleber, bruna).
gerou(maria, julia).
gerou(maria, pedro).
gerou(pedro, lucas).

feminino(kelly).
feminino(maria).
feminino(julia).
feminino(bruna).
masculino(cleber).
masculino(pedro).
masculino(lucas).

% REGRAS
filho(Y, X) :- 
    gerou(X, Y).

mae(X, Y) :- % X é mãe de Y se X gerou Y e X é feminino
    gerou(X, Y),
    feminino(X).

avos(X, Z) :-
    gerou(X, Y),
    gerou(Y, Z).