;------------------------------------------------
; Ana Gabrielle da Silva Oliveira   RA: 10721801
; Kauê Lima Rodrigues Meneses       RA: 10410594
; Theo Esposito Simões Resende      RA: 10721356
;------------------------------------------------

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
(defun lestring (i linha)
    (cond
        ((> i 7) nil)
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
        ((> j 7) nil)
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
; Se for um número (como os 8 do exemplo), consideramos a casa 'vazia'
(defun obter-peca (i j tabuleiro)
  (cond
    ((or (< i 0) (> i 7) (< j 0) (> j 7)) 'fora) ; Saiu dos limites do tabuleiro
    ((numberp (pega i tabuleiro)) 'vazio)         ; Linha vazia (representada por números)
    ((stringp (pega i tabuleiro)) (char (pega i tabuleiro) j)) ; Retorna o caractere da peça
    (t 'vazio)))

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

; Função principal solicitada pelo projeto: acha o rei branco, lista todas
; as peças pretas e verifica se alguma delas está atacando o rei branco.
; Retorna t se o rei branco estiver em xeque, nil caso contrário.
(defun chess (tabuleiro)
    (cond
        ((null tabuleiro) nil)
        (t (let* ((pos-r (acharei tabuleiro))
                  (pecas-pretas (listar-pecas-pretas tabuleiro)))
             (alguma-peca-ataca-p pecas-pretas tabuleiro pos-r)))))


(write (chess (read)))
(terpri)
; para rodar, execute: sbcl --script chess.lsp
; e digite a entrada para o tabuleiro

; ex: ("tcbdrbct" "pppppppp" 8 8 8 8 "PPPPPPPP" "TCBDRBCT")