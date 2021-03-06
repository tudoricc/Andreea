(include "Reflection.scm")
; functii ajutatoare
;ia primul element din fiecare sublista a listei sau, daca nu este o sublista, se ia elementul pe care ne aflam
(define (primul L)
  (if (or (null? L) (null? (car L)))
      '()
      ; daca avem sublista luam primul element din sublista si il adaugam la noua lista
      (if (list? (car L))
          (cons (car (car L)) (primul (cdr L)))
          ; iar daca este doar  un element, luam elementul respectiv si il adaugam la noua lista
          (cons (car L) (primul (cdr L))))))

; numara de cate ori apare un cuvant intr-o lista
(define (apare nume L)
  (let iter ((L L) (nr 0))
    (if (null? L)
        nr
        (if (equal? nume (car L))
            (iter (cdr L) (+ nr 1))
            (iter (cdr L) nr)))))

; functia in care determinam tipul de recursivitate
(define (detect-recursion f)
  (let iter ((L (cons (get-function-body f) '())) (nume (get-function-name f)))
    ; daca se ajunge la lista goala si nu s-a iesit inca din recursivitate, atunci inseamna ca functia nu este recursiva
    (if (null? L)
        'NON-RECURSIVE
        ;daca primul elem din L este o lista, aplicam functia primul(cu descrierea de mai sus)
    (if (and (list? (car L)) (not (null? (car L))))
        (let ((primele (primul (car L))))
          ; daca lista incepe cu if sau cond, inseamna ca nu se aplica un operator de aduanre sau ceva de genul intre apelurile recursive ale functiei, deci 
          ;este TAIL-RECURSIVE
          (cond ((and (>= (apare nume primele) 1) (or (eq? (car primele) 'if) (eq? (car primele) 'cond))) 'TAIL-RECURSIVE)
                ;daca numele fucntiei apare doar o data in acel apel si apelul nu incepe cu if sau cond, inseamna ca s-a aplicat un operator intre apelul 
                ;recursiv al functiei si o variabila sau o constanta => STACK-RECURSIVE
                ((and (= (apare nume primele) 1) (not (or (eq? (car primele) 'if) (eq? (car primele) 'cond)))) 'STACK-RECURSIVE)
                ; daca avemc onditiile de la stack recursive dar se apeleaza funtia de mai mult de o data, inseamna ca functia este TREE-RECURSIVE
                ((and (> (apare nume primele) 1) (not (or (eq? (car primele) 'if) (eq? (car primele) 'cond)))) 'TREE-RECURSIVE)
                ; daca primul element din lista este tot o lista, atunci facem append intre restul primei subliste si restul listei noastre
                (else (iter (append (cdr (car L)) (cdr L)) nume))))
        ;daca primul element nu este lista, trecem cu CDR mai departe
        (iter (cdr L) nume)))))