(define (addition a b)
  (+ a b))

(define (subtraction a b)
  (- a b))

(define (multiplication a b)
  (let loop ((count b) (result 0))
    (if (= count 0)
        result
        (loop (- count 1) (addition result a)))))

(define (division a b)
  (if (= b 0)
      (error "Division by zero")
      (let loop ((dividend a) (quotient 0))
        (if (< dividend b)
            quotient
            (loop (subtraction dividend b) (addition quotient 1))))))

(define (modulus a b)
  (if (= b 0)
      (error "Division by zero")
      (subtraction a (multiplication (division a b) b))))
