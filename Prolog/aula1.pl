% AULA 1

a. /* a é verdadeiro e isto é um fato */
b. /* b é verdadeiro e isto é um fato */
c. /* c é verdadeiro e isto é um fato */

d :- a, x. /* d é verdadeiro SE a E x forem verdadeiros e isto é uma regra */
           /* OU */
d :- c.    /* d é verdadeiro SE c for verdadeiro e isto é uma regra */

x :- fail. /* x é falso e isto é uma regra*/

%-----------------------------------------------------------------------------

/* isso NÃO É UMA FUNÇÃO, mas sim um PREDICADO
   a única coisa que retorna disso é verdadeiro ou falso */

/* toda VARIÁVEL começa com letra maiúscula, e todo predicado com letra minúscula */
/* soma é um predicado com aridade 3 */
soma(A,B,Resp) :- Resp is A+B.

%---------------------------------LISTAS EM PROLOG------------------------------------

% 
/*
[] isto é a lista vazia
[6,a,[2,5]] isto é uma lista com 3 elementos (pode ser formado por tipos diferentes)

Suponha a lista [1,2,3]

Podemos nos referir a esta lista com L, X, M, Lista etc.
Este é o modo de se referir a esta lista como um todo.

O outro modo de se lidar com listas em Prolog é através da notação head-tail (cabeça-cauda):
[A|X]
[Head|Tail]
[A|As]

Vamos supor qu estamos olhando para dentro da lista
usando pra isto a notação [A|X]. Então:

A = 1
X = [2,3]

ou seja, A é um elemento e X é a LISTA do resto.

Para entendermos como  funciona essa notação, as expressões abaixo são a mesma coisa.

[1,2,3] = [1|[2,3]] = [1|[2|[3]]] = [1|[2|[3|[]]]]

*/

% predicado que retorna o primeiro e segundo elemento da lista
prog([A,B|X],A,B). % pode colocar underline no lugar do X para mostrar que "não importa" 

% predicado que retorna o primeiro e segundo elemento da lista usando pipe
prog2([A|[B|X]],A,B).

%----------------------------------FATORIAL-------------------------------------------

fat(0,1). % o fatorial de 0 é 1 (caso base) - fato
fat(N,R) :-
    N2 is N-1, % NÃO FAÇA "N IS N-1", ISSO NÃO EXISTE, CRIA UMA VARIAVEL NOVA!
    fat(N2,R2),
    R is N*R2.
% "fatorial de N é R se for N*R2, o R2 é o fatorial do N-1"

%----------------------------------Tamanho da Lista-----------------------------------

tam([],0). % o tamanho de uma lista vazia é 0 (caso base)
tam([A|As],R) :-
    tam(As,R2),
    R is R2 + 1.

%----------------------------------Soma da Lista--------------------------------------

soma([],0). % o tamanho de uma lista vazia é 0 (caso base)
soma([A|As],R) :-
    soma(As,R2),
    R is R2 + A.

%----------------------------------Soma de Duas Listas--------------------------------------

/*
Exemplo - primeiro com primeiro elemento, segundo com segundo...
soma2L([1,2,3],[10,100],R).
R = [11,102,3]
*/

soma2L(L,[],L). % se a primeira lista ainda tem alguem e segunda acabou, devolve primeira lista
soma2L([],L,L). % se a primeira acabou e a segunda ainda tem, também devolve a primeira
soma2L([A|As],[B|Bs],[R|Rs]) :-
    R is A+B,
    soma2L(As,Bs,Rs). % chama recursivamente pras caudas

% programa RECURSIVO PURO, sem acumuladores. aqui, a resposta é criada antes da chamada recursiva -> [R|Rs]

%----------------------------------Membro da Lista--------------------------------------

% devolve verdadeiro ou falso se um elemento é membro de uma lista

membro(E,[E|_]). % "se o elemento que eu procuro é igual a cabeça da lsita, achei"
membro(A,[_|X]):- membro(A,X). % ignora a cabeça e procura no restante da lista.