;------------------------------------------------
; Ana Gabrielle da Silva Oliveira   RA: 10721801
; Kauê Lima Rodrigues Meneses       RA: 10410594
; Theo Esposito Simões Resende      RA: 10721356
;------------------------------------------------
;
; COMO EXECUTAR:
;   sbcl --script chess.lisp
; e depois digitar a entrada no teclado:
;   (chess ("tcbdrbct" "pppppppp" 8 8 8 8 "PPPPPPPP" "TCBDRBCT"))
; Saída esperada:
;   NIL
; (o programa também aceita só a lista do tabuleiro, sem o "chess":
;   ("tcbdrbct" "pppppppp" 8 8 8 8 "PPPPPPPP" "TCBDRBCT") )
;
; Exemplo com xeque (torre preta na coluna do rei branco):
;   (chess (8 8 8 8 "4t3" 8 8 "4R3"))
; Saída esperada:
;   T
;
; Letras: t=torre c=cavalo b=bispo d=dama r=rei p=peão
;   minúsculas = peças pretas, MAIÚSCULAS = peças brancas.
;   Números = casas vazias consecutivas (notação Forsyth);
;   um 8 sozinho é uma linha inteira vazia. A primeira linha da lista é a linha 0 (topo,
;   onde ficam as pretas); a última é a linha 7 (onde ficam as brancas).


; EXPANDIR A NOTAÇÃO FORSYTH -----------------------------------------
; Na notação Forsyth, dígitos dentro de uma linha representam casas vazias
; (ex.: "4t3" = quatro vazias, torre preta, três vazias). Para o resto do
; programa poder tratar cada caractere como UMA casa, convertemos cada linha
; para uma string de exatamente 8 caracteres, onde casa vazia = #\.
; Ex: "4t3" -> "....t..."   e   o número 8 -> "........"

; Expande uma linha (número ou string) para uma string de 8 casas
(defun expande-linha (linha)
    (cond
        ((numberp linha) (make-string linha :initial-element #\.))
        (t (expande-str 0 linha))))

; Percorre a string caractere por caractere:
; dígito -> vira essa quantidade de pontos; qualquer outro caractere é mantido
(defun expande-str (i s)
    (cond
        ((>= i (length s)) "")
        ((digit-char-p (char s i))
         (concatenate 'string
                      (make-string (digit-char-p (char s i)) :initial-element #\.)
                      (expande-str (+ i 1) s)))
        (t (concatenate 'string
                        (string (char s i))
                        (expande-str (+ i 1) s)))))

; Aplica expande-linha em todas as linhas do tabuleiro
(defun expande-tabuleiro (tabuleiro)
    (cond
        ((null tabuleiro) nil)
        (t (cons (expande-linha (car tabuleiro))
                 (expande-tabuleiro (cdr tabuleiro))))))


; ENCONTRAR O REI BRANCO

; Função de entrada para encontrar o Rei Branco (#\R)
; Inicia a busca recursiva a partir da linha 0
(defun acharei (tabuleiro)
    (acharei* 0 7 tabuleiro))

; Percorre o tabuleiro linha por linha recursivamente
; Se achar o Rei na linha atual (usando lestring), retorna as coordenadas no formato (linha coluna)
; Caso contrário, avança para buscar na próxima linha (+ 1 i)
(defun acharei* (i j tabuleiro)
  (let ((pos (and (stringp (car tabuleiro)) (lestring 0 (car tabuleiro)))))
    (cond
      ((null tabuleiro) nil)                      
      (pos (list i pos))            
      (t (acharei* (+ 1 i) j (cdr tabuleiro))))))

; Percorre os caracteres de uma string (que representa uma linha do tabuleiro)
; Retorna o índice da coluna i se encontrar o caractere #\R (rei branco)
; (também para se a linha tiver menos de 8 caracteres, evitando erro de índice)
(defun lestring (i linha)
    (cond
        ((or (> i 7) (>= i (length linha))) nil)
        ((eql (char linha i) #\R) i)
        (t (lestring (+ 1 i) linha))))



; LISTAR AS PEÇAS PRETAS

; Função de entrada para criar uma lista com todas as peças pretas do tabuleiro
; Inicia a varredura a partir da linha 0
(defun listar-pecas-pretas (tabuleiro)
    (listar-pecas-pretas* 0 tabuleiro))

; Percorre as linhas do tabuleiro recursivamente
; Se a linha for uma string, junta as peças achadas nessa linha (usando lelinha-pretas)
; com as peças achadas nas linhas seguintes, montando uma lista unica
(defun listar-pecas-pretas* (i tabuleiro)
    (cond
        ((null tabuleiro) nil)
        ((stringp (car tabuleiro))
         (append (lelinha-pretas 0 i (car tabuleiro))
                 (listar-pecas-pretas* (+ 1 i) (cdr tabuleiro))))
        (t (listar-pecas-pretas* (+ 1 i) (cdr tabuleiro)))))

; Lê uma linha específica caractere por caractere (da coluna 0 a 7)
; Se encontrar uma peça preta, cria uma lista com o formato: (peça (linha coluna))
; e junta com as demais peças encontradas na mesma linha
(defun lelinha-pretas (j i linha)
    (cond
        ((or (> j 7) (>= j (length linha))) nil)
        ((peca-preta-p (char linha j))
         (cons (list (char linha j) (list i j))
               (lelinha-pretas (+ 1 j) i linha)))
        (t (lelinha-pretas (+ 1 j) i linha))))

; Função auxiliar que verifica se um caractere é uma peça preta
; Retorna verdadeiro se for uma das letras minúsculas na lista
(defun peca-preta-p (c)
    (member c '(#\t #\c #\b #\d #\r #\p)))


; VERIFICAÇÕES DE ATAQUE POR TIPO DE PEÇA -----------------------------

; Pega o i-ésimo elemento de uma lista
(defun pega (i tabuleiro) 
  (cond
    ((null tabuleiro) nil)
    ((= i 0) (car tabuleiro))
    (t (pega (- i 1) (cdr tabuleiro)))
  )
)

; Retorna o que tem em uma coordenada (i, j) do tabuleiro
; Como o tabuleiro já foi expandido (Forsyth), toda linha é uma string de
; 8 caracteres e a casa vazia é representada pelo caractere #\.
(defun obter-peca (i j tabuleiro)
  (let ((linha (pega i tabuleiro)))
    (cond
      ((or (< i 0) (> i 7) (< j 0) (> j 7)) 'fora) ; Saiu dos limites do tabuleiro
      ((not (stringp linha)) 'fora)                ; Linha inexistente
      ((>= j (length linha)) 'fora)                ; Linha curta demais
      ((eql (char linha j) #\.) 'vazio)            ; Casa vazia
      (t (char linha j)))))                        ; Retorna o caractere da peça

; Verifica se há um caminho livre a partir de (i, j) indo na direção dir-i, dir-j
; até encontrar o rei branco na posição pos-r.
(defun verifica-raio (i j dir-i dir-j pos-r tabuleiro)
  (let ((ni (+ i dir-i)) ; próxima linha
        (nj (+ j dir-j))) ; próxima coluna
    (cond
      ; Se a próxima posição for onde está o rei branco, então xeque
      ((and (= ni (car pos-r)) (= nj (cadr pos-r))) t) 
      ; Se saiu do tabuleiro, o raio acaba e não achou o rei
      ((eql (obter-peca ni nj tabuleiro) 'fora) nil)   
      ; Se a casa não está vazia (esbarrou em outra peça no caminho), o ataque é bloqueado
      ((not (eql (obter-peca ni nj tabuleiro) 'vazio)) nil) 
      ; Se está vazia, continua buscando na mesma direção recursivamente
      (t (verifica-raio ni nj dir-i dir-j pos-r tabuleiro)))))


; A torre se move em linhas retas: vertical e horizontal
; Vetores de direção: (1, 0), (-1, 0), (0, 1), (0, -1)
(defun ataque-torre (pos-t pos-r tabuleiro)
  (let ((i (car pos-t)) (j (cadr pos-t)))
    (or (verifica-raio i j 1 0 pos-r tabuleiro)
        (verifica-raio i j -1 0 pos-r tabuleiro)
        (verifica-raio i j 0 1 pos-r tabuleiro)
        (verifica-raio i j 0 -1 pos-r tabuleiro))))

; O bispo se move pelas diagonais
; Vetores de direção: (1, 1), (1, -1), (-1, 1), (-1, -1)
(defun ataque-bispo (pos-b pos-r tabuleiro)
  (let ((i (car pos-b)) (j (cadr pos-b)))
    (or (verifica-raio i j 1 1 pos-r tabuleiro)
        (verifica-raio i j 1 -1 pos-r tabuleiro)
        (verifica-raio i j -1 1 pos-r tabuleiro)
        (verifica-raio i j -1 -1 pos-r tabuleiro))))

; A dama é a junção dos movimentos da Torre e do Bispo
(defun ataque-dama (pos-d pos-r tabuleiro)
  (or (ataque-torre pos-d pos-r tabuleiro)
      (ataque-bispo pos-d pos-r tabuleiro)))

; Verifica se a distancia absoluta (linha e coluna) forma o movimento de L
(defun ataque-cavalo (pos-c pos-r tabuleiro)
  (let ((dist-i (abs (- (car pos-c) (car pos-r))))  ; diferença nas linhas
        (dist-j (abs (- (cadr pos-c) (cadr pos-r))))) ; diferença nas colunas
    (or (and (= dist-i 1) (= dist-j 2))
        (and (= dist-i 2) (= dist-j 1)))))

; O peão preto ataca na diagonal "pra frente" dele, ou seja, indo pra linha
; seguinte (i+1), já que as peças pretas começam em cima e avançam pra baixo
(defun ataque-peao (pos-pe pos-r)
  (let ((lin-p (car pos-pe)) (col-p (cadr pos-pe)))
    (or (and (= (car pos-r) (+ lin-p 1)) (= (cadr pos-r) (+ col-p 1)))
        (and (= (car pos-r) (+ lin-p 1)) (= (cadr pos-r) (- col-p 1))))))

; O rei preto ataca qualquer uma das 8 casas adjacentes a ele
(defun ataque-rei (pos-rp pos-r)
  (let ((dist-i (abs (- (car pos-rp) (car pos-r))))
        (dist-j (abs (- (cadr pos-rp) (cadr pos-r)))))
    (and (<= dist-i 1) (<= dist-j 1)
         (not (and (= dist-i 0) (= dist-j 0))))))


; ORQUESTRAÇÃO -------------------------------------------------------

; Recebe uma peça preta (o caractere) e a posição dela, e decide qual
; verificação de ataque usar de acordo com o tipo da peça
(defun peca-ataca-rei-p (peca pos-p tabuleiro pos-r)
  (cond
    ((eql peca #\t) (ataque-torre pos-p pos-r tabuleiro))
    ((eql peca #\c) (ataque-cavalo pos-p pos-r tabuleiro))
    ((eql peca #\b) (ataque-bispo pos-p pos-r tabuleiro))
    ((eql peca #\d) (ataque-dama pos-p pos-r tabuleiro))
    ((eql peca #\r) (ataque-rei pos-p pos-r))
    ((eql peca #\p) (ataque-peao pos-p pos-r))
    (t nil)))

; Percorre a lista de peças pretas (cada elemento no formato (peça (linha coluna)))
; e retorna t assim que alguma delas ataca o rei branco; se nenhuma atacar, nil
(defun alguma-peca-ataca-p (pecas-pretas tabuleiro pos-r)
  (cond
    ((null pecas-pretas) nil)
    ((peca-ataca-rei-p (caar pecas-pretas) (cadar pecas-pretas) tabuleiro pos-r) t)
    (t (alguma-peca-ataca-p (cdr pecas-pretas) tabuleiro pos-r))))


; FUNÇÃO PRINCIPAL --------------------------------------------------

; Função principal solicitada pelo projeto: expande a notação Forsyth,
; acha o rei branco, lista todas as peças pretas e verifica se alguma delas
; está atacando o rei branco.
; Aceita a entrada nas duas formas:
;   (chess ("tcbdrbct" ...))   -> forma do enunciado (o 1o elemento é o símbolo chess)
;   ("tcbdrbct" ...)           -> só a lista do tabuleiro
; Retorna t se o rei branco estiver em xeque, nil caso contrário
; (nil também se não houver rei branco no tabuleiro).
(defun chess (entrada)
    (cond
        ((null entrada) nil)
        (t (let* ((tab (if (eq (car entrada) 'chess) (cadr entrada) entrada))
                  (tabuleiro (expande-tabuleiro tab))
                  (pos-r (acharei tabuleiro))
                  (pecas-pretas (listar-pecas-pretas tabuleiro)))
             (and pos-r
                  (alguma-peca-ataca-p pecas-pretas tabuleiro pos-r))))))

; Lê a entrada do teclado, calcula e escreve o resultado (T ou NIL)
(write (chess (read)))
(terpri)