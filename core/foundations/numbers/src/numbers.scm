(define (sum_of_first_n_rec n)
  (if (<= n 0)
      0
      (+ n (sum_of_first_n_rec (- n 1)))))

(define (factorial_rec n)
  (if (<= n 1)
      1
      (* n (factorial_rec (- n 1)))))

(define (fibonacci_rec n)
  (if (<= n 1)
      n
      (+ (fibonacci_rec (- n 1))
         (fibonacci_rec (- n 2)))))

(define (greatest_common_divisor_rec a b)
  (if (= b 0)
      a
      (greatest_common_divisor_rec b (remainder a b))))

(define (least_common_multiple_rec a b)
  (if (or (= a 0) (= b 0))
      0
      (* (quotient a (greatest_common_divisor_rec a b)) b)))

(define (sum_of_first_n_acc n)
  (let loop ((current n) (acc 0))
    (if (<= current 0)
        acc
        (loop (- current 1) (+ current acc)))))

(define (factorial_acc n)
  (let loop ((current n) (acc 1))
    (if (<= current 1)
        acc
        (loop (- current 1) (* current acc)))))

(define (fibonacci_acc n)
  (let loop ((position n) (acc2 0) (acc1 1))
    (cond ((<= position 0) acc2)
          ((<= position 2) (+ acc1 acc2))
          (else (loop (- position 1) acc1 (+ acc1 acc2))))))

(define (greatest_common_divisor_acc a b)
  (let loop ((x a) (y b))
    (if (= y 0)
        x
        (loop y (remainder x y)))))

(define (least_common_multiple_acc a b)
  (if (or (= a 0) (= b 0))
      0
      (* (quotient a (greatest_common_divisor_acc a b)) b)))

(define (sum_of_first_n_ite n)
  (do ((current 1 (+ current 1))
       (result 0 (+ result current)))
      ((> current n) result)))

(define (factorial_ite n)
  (do ((current 2 (+ current 1))
       (result 1 (* result current)))
      ((> current n) result)))

(define (fibonacci_ite n)
  (if (<= n 1)
      n
      (do ((current 2 (+ current 1))
           (acc2 0 acc1)
           (acc1 1 (+ acc1 acc2)))
          ((> current n) acc1))))

(define (greatest_common_divisor_ite a b)
  (do ((x a y)
       (y b (remainder x y)))
      ((= y 0) x)))

(define (least_common_multiple_ite a b)
  (if (or (= a 0) (= b 0))
      0
      (* (quotient a (greatest_common_divisor_ite a b)) b)))
