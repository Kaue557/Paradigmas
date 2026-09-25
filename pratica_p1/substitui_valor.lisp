#|
Escreva uma função substitui que receba um valor x, um valor y e uma lista de inteiros.
A função deve substituir todas as ocorrências de x por y.

exemplo:
entrada: (substitui 3 10 '(1 3 5 3 7 3))
saída: (1 10 5 10 7 10)
|#

(defun substitui (x y lst)
    (cond
        ((null lst) nil) ; se lista for vazia
        (t
            (cond
                ((eql (car lst) x)
                    (cons y ; coloca y no lugar do x e prossegue com a lista
                        (substitui x y (cdr lst)))) 
                (t ; senão
                    (cons (car lst) ; mantém o elemento e segue pro resto
                          (substitui x y (cdr lst)))))))) ; se não for igual, só prossegue            

(write (substitui 3 10 '(1 3 5 3 7 3)))