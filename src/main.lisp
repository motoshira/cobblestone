(defpackage #:cobblestone/main
  (:nicknames #:cobblestone
              #:cb)
  (:use #:cl)
  (:import-from #:cobblestone/test
                #:make-test
                #:run-test
                #:run-tests))

(in-package #:cobblestone/main)

;; TODO:
;; - Generator

(define-symbol-macro *alphabet-chars* (loop for i below 26 collect (code-char (+ (char-code #\a)
                                                                        i))))

(defmacro %gen-integer (min-value max-value)
  `(+ ,min-value
      (random (1+ (- ,max-value ,min-value)))))

(defmacro %gen-char (chars)
  (let* ((%chars (gensym "CHARS"))
         (chars (or chars *alphabet-chars*)))
    `(let ((,%chars ',chars))
       (dolist (c ,%chars)
         (unless (typep c 'character)
           (error (make-condition 'type-error))))
       (nth (random (length ,%chars)) ,%chars))))

(defmacro %gen-string (length &key (chars))
  (check-type length number)
  (let* ((chars (or chars *alphabet-chars*)))
    `(coerce (loop repeat ,length collect (%gen-char ,chars))
             'string)))
