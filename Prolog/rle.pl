l1([90,7,1,3,7,54,3,2,9]).
/*lista usada para ordenações*/

lrle([a,a,a,a,a,b,b,b,b,c,c,c,d,a,a,a,a,a,a]).

lrld([(a,5),(b,4),(c,3),(d,1),(a,6)]).

/*rle (run lenght encoding)*/

rle([],[]). /*se lista vazia - devolve vazia*/
rle([E|Es],R) :-
    rle(Es,E,1,R). /*esse rle é diferente do de cima, tipo um aux.*/
    /*rle(ListaRestante, ElementoAtual, Contador, Resultado)*/

rle([],E,N,[(E,N)]). /*caso base - fim da lista*/

rle([E|X],E,N,R) :- /*se a cabeça da lista restante for igual ao elemento que já estamos contando.*/
    N2 is N+1, rle(X,E,N2,R).

rle([A|As],E,N,[(E,N)|X]) :- /*caso em que temos um novo caractere*/
    rle(As,A,1,X).

/*====================================================================*/
rpt(_,0,[]). /*repita qualquer coisa 0 vezes = lista vazia*/
rpt(E,N,[E|X]) :-
    /*vai em direção ao caso base*/
    N2 is N-1, rpt(E,N2,X). /*"repita o elemento uma vez a menos"*/


/*descompactador do que fizemos no rle. rpt -> "repita"*/
/*(!)usamos o rpt para isso*/
rld([],[]).
rld([(E,N)|X],R) :- 
    rpt(E,N,L),
    rld(X,T),
    append(L,T,R).