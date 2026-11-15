/* ============================================================================
Projeto 2: Esta em xeque? (Prolog)
Integrantes do grupo:
  - ANA GABRIELLE DA SILVA OLIVEIRA - 10721801
  - KAUÊ LIMA RODRIGUES MENESES - 10410594
  - THEO ESPOSITO SIMÕES RESENDE - 10721356
============================================================================== */


/* -----------------------------------------------------------------------------
COMO EXECUTAR (SWI-Prolog)

  1) Abra o interpretador carregando o arquivo:
         swipl chess.pl

  2) Faca a consulta passando o tabuleiro em notacao Forsyth:
         ?- chess(["tcbdrbct","pppppppp",8,8,8,8,"PPPPPPPP","TCBDRBCT"]).
         false.

         ?- chess(["4r3",8,8,8,8,8,"4t3","4R3"]).
         true.
----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
FORMATO DA ENTRADA

  Uma lista com 8 elementos, um para cada linha do tabuleiro, comecando pela
  linha 8 (lado das pretas) e terminando na linha 1 (lado das brancas).
  Cada elemento pode ser:
    - um numero  : 8 significa "linha com 8 casas vazias";
    - uma string : cada letra e uma peca e cada digito e uma quantidade de
                   casas vazias seguidas. Ex.: "2t2R2" = 2 vazias, torre
                   preta, 2 vazias, rei branco, 2 vazias.

  Pecas (nomes em portugues):
    t = torre   c = cavalo   b = bispo   d = dama   r = rei   p = peao
  Letra minuscula = peca PRETA.  Letra maiuscula = peca BRANCA.

SAIDA
  true   se o rei branco ('R') esta em xeque;
  false  caso contrario.
  (e a propria resposta do Prolog: a consulta tem sucesso ou falha)

----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
IDEIA GERAL DA SOLUCAO

  1) Converter a entrada em uma matriz 8x8 (lista de 8 listas de 8 casas),
     onde cada casa e um caractere: a letra da peca ou '-' se estiver vazia.
  2) Procurar a posicao (Linha, Coluna) do rei branco 'R'.
  3) Em vez de olhar cada peca preta e ver se ela alcanca o rei, fazemos o
     contrario: partimos da casa do rei e olhamos "para fora":
       - nas 4 direcoes retas    -> a primeira peca encontrada e torre/dama?
       - nas 4 direcoes diagonais-> a primeira peca encontrada e bispo/dama?
       - nos 8 saltos em "L"     -> ha um cavalo preto?
       - nas 2 diagonais de cima -> ha um peao preto?
       - nas 8 casas vizinhas    -> ha o rei preto?
     Se qualquer uma dessas perguntas for verdadeira, o rei esta em xeque.
------------------------------------------------------------------------------  */


% -----------------------------------------------------------------------------
% chess(+Entrada)
%   Predicado principal. Tem sucesso (true) se o rei branco esta em xeque e
%   falha (false) caso contrario.
%   O corte (!) no final descarta as outras formas de provar o xeque: sem ele,
%   se o rei estivesse sendo atacado por mais de uma peca, o Prolog ofereceria
%   varias respostas "true" em vez de uma so.
% -----------------------------------------------------------------------------

chess(Entrada) :-
    monta_tabuleiro(Entrada, Tab),      % passo 1: matriz 8x8
    casa(Tab, L, C, 'R'),               % passo 2: acha o rei branco
    atacado(Tab, L, C),                 % passo 3: alguma peca preta o ataca?
    !.


% 1 - CONVERSAO DA ENTRADA EM MATRIZ 8x8

% monta_tabuleiro(+Entrada, -Tab)
%   Percorre a lista de entrada convertendo cada linha.
monta_tabuleiro([], []).
monta_tabuleiro([Linha|Resto], [Casas|RestoTab]) :-
    codigos_da_linha(Linha, Codigos),
    expande(Codigos, Casas),
    monta_tabuleiro(Resto, RestoTab).

% codigos_da_linha(+Linha, -Codigos)
%   Transforma a linha em uma lista de codigos de caracteres.
%   atom_codes e necessario aqui porque nao ha outra forma de "abrir" uma
%   string ou um numero: ele funciona para os dois casos.
%     "pp2"  ->  [112,112,50]         8  ->  [56]

codigos_da_linha([], []) :- !.
codigos_da_linha([X|Xs], [X|Xs]) :- !.
codigos_da_linha(Linha, Codigos) :-
    atom_codes(Linha, Codigos).

% expande(+Codigos, -Casas)
%   Troca cada digito por N casas vazias e cada letra pelo seu caractere.
%   Os digitos '1'..'8' tem codigos 49..56; subtraindo 48 obtemos o numero.
expande([], []).
expande([Cod|Resto], Casas) :-
    Cod >= 49, Cod =< 56, !,            % e um digito de 1 a 8
    N is Cod - 48,
    vazias(N, Vazias),
    expande(Resto, CasasResto),
    append(Vazias, CasasResto, Casas).
expande([Cod|Resto], [Peca|CasasResto]) :-
    char_code(Peca, Cod),               % codigo -> caractere (ex.: 112 -> p)
    expande(Resto, CasasResto).

% vazias(+N, -Lista)
%   Lista com N casas vazias ('-').
vazias(0, []) :- !.
vazias(N, ['-'|Resto]) :-
    N1 is N - 1,
    vazias(N1, Resto).


% 2 - ACESSO AS CASAS DO TABULEIRO

% enesimo(?N, +Lista, ?Elem)
%   Elem e o N-esimo elemento da Lista (contando a partir de 1).
%   Funciona nos dois sentidos:
%     - N conhecido      -> devolve o elemento daquela posicao;
%     - N desconhecido   -> percorre a lista devolvendo a posicao de Elem
%                           (e assim que encontramos o rei).
%   Por isso a soma N is N1 + 1 vem DEPOIS da chamada recursiva: nesse ponto
%   N1 ja tem valor, seja qual for o sentido de uso.
enesimo(1, [Elem|_], Elem).
enesimo(N, [_|Resto], Elem) :-
    enesimo(N1, Resto, Elem),
    N is N1 + 1.

% casa(+Tab, ?L, ?C, ?Peca)
%   Peca e o conteudo da casa na linha L e coluna C (ambas de 1 a 8).
%   L = 1 e a primeira linha da entrada (linha 8 do xadrez, lado das pretas).
%   Se L ou C estiverem fora do tabuleiro, o predicado simplesmente falha,
%   e e isso que usamos como "teste de borda" no resto do programa.
casa(Tab, L, C, Peca) :-
    enesimo(L, Tab, Linha),
    enesimo(C, Linha, Peca).


% 3 - REGRAS DE ATAQUE
%   atacado(+Tab, +L, +C): alguma peca preta ataca a casa (L, C).
%   Cada clausula abaixo trata de um tipo de peca.

% --- Torre ou dama: linhas e colunas -----------------------------------------
% Olhamos em cada direcao reta; a primeira peca que aparecer no caminho
% precisa ser torre (t) ou dama (d) preta. Se for qualquer outra peca, ela
% bloqueia o caminho e nao ha ataque por ali.
atacado(Tab, L, C) :-
    direcao_reta(DL, DC),
    primeira_peca(Tab, L, C, DL, DC, Peca),
    torre_ou_dama(Peca).

% --- Bispo ou dama: diagonais ------------------------------------------------
% Mesma ideia, agora andando nas diagonais.
atacado(Tab, L, C) :-
    direcao_diagonal(DL, DC),
    primeira_peca(Tab, L, C, DL, DC, Peca),
    bispo_ou_dama(Peca).

% --- Cavalo ------------------------------------------------------------------
% O cavalo salta, entao nao existe bloqueio: basta haver um cavalo preto (c)
% em uma das 8 casas em "L" ao redor do rei.
atacado(Tab, L, C) :-
    salto_cavalo(DL, DC),
    L1 is L + DL,
    C1 is C + DC,
    casa(Tab, L1, C1, c).

% --- Peao --------------------------------------------------------------------
% Os peoes pretos andam "para baixo" na matriz (linha aumenta) e capturam na
% diagonal. Logo, um peao preto ataca o rei se estiver UMA LINHA ACIMA dele
% (L - 1), na coluna da esquerda ou da direita.
atacado(Tab, L, C) :-
    lado(DC),
    L1 is L - 1,
    C1 is C + DC,
    casa(Tab, L1, C1, p).

% --- Rei preto ---------------------------------------------------------------
% Em uma partida legal os reis nunca ficam lado a lado, mas tratamos o caso
% para o programa responder corretamente a qualquer tabuleiro informado.
atacado(Tab, L, C) :-
    vizinha(DL, DC),
    L1 is L + DL,
    C1 is C + DC,
    casa(Tab, L1, C1, r).


% primeira_peca(+Tab, +L, +C, +DL, +DC, -Peca)
%   Partindo de (L, C) e andando de (DL, DC) em (DL, DC), devolve a primeira
%   peca encontrada. Falha se chegar a borda sem encontrar nenhuma
%   (porque casa/4 falha fora do tabuleiro).
primeira_peca(Tab, L, C, DL, DC, Peca) :-
    L1 is L + DL,
    C1 is C + DC,
    casa(Tab, L1, C1, Conteudo),
    continua(Conteudo, Tab, L1, C1, DL, DC, Peca).

% continua/7: decide o que fazer com o conteudo da casa visitada.
%   - casa vazia  -> segue andando na mesma direcao;
%   - casa ocupada-> essa e a primeira peca do caminho (para aqui).
continua('-', Tab, L, C, DL, DC, Peca) :- !,
    primeira_peca(Tab, L, C, DL, DC, Peca).
continua(Peca, _, _, _, _, _, Peca).


% 4 - FATOS AUXILIARES (pecas e deslocamentos)
%   Cada deslocamento e um par (variacao da linha, variacao da coluna).

% Pecas pretas que atacam em linha reta e na diagonal.
torre_ou_dama(t).
torre_ou_dama(d).

bispo_ou_dama(b).
bispo_ou_dama(d).

% Cima, baixo, esquerda, direita.
direcao_reta(-1,  0).
direcao_reta( 1,  0).
direcao_reta( 0, -1).
direcao_reta( 0,  1).

% As quatro diagonais.
direcao_diagonal(-1, -1).
direcao_diagonal(-1,  1).
direcao_diagonal( 1, -1).
direcao_diagonal( 1,  1).

% Os oito saltos em "L" do cavalo.
salto_cavalo(-2, -1).
salto_cavalo(-2,  1).
salto_cavalo(-1, -2).
salto_cavalo(-1,  2).
salto_cavalo( 1, -2).
salto_cavalo( 1,  2).
salto_cavalo( 2, -1).
salto_cavalo( 2,  1).

% Colunas vizinhas (esquerda e direita), usadas pelo peao.
lado(-1).
lado( 1).

% As oito casas ao redor de uma casa = direcoes retas + diagonais.
vizinha(DL, DC) :- direcao_reta(DL, DC).
vizinha(DL, DC) :- direcao_diagonal(DL, DC).

% Exemplo de entrada:
% chess(["tcbdrbct","pppppppp",8,8,8,8,"PPPPPPPP","TCBDRBCT"]).
