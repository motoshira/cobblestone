(defpackage :cobblestone/test
  (:nicknames #:cb/test)
  (:use #:cl)
  (:import-from #:lparallel)
  (:export #:make-test
           #:run-test))

(in-package #:cobblestone/test)


(defstruct (test-case (:constructor %make-test)
                      (:conc-name test-))
  (name nil :type (or null string))
  (fn nil :type function)
  (doc nil :type (or null string)))

;; TODO: fixture

(defmacro make-test ((&key name doc) &body body)
  `(%make-test
    ,@(when name
        `(:name ,name))
    ,@(when doc
        `(:doc ,doc))
    :fn (lambda ()
          ,@body)))

(defstruct (result (:constructor %make-result))
  (name nil :type (or null string))
  (doc "" :type (or null string))
  (fn nil :type function)
  (result nil :type (member :pass :fail :skip))
  (error nil :type (or null condition)))

(defun run-test (test-case)
  (with-slots (name fn doc) test-case
    (multiple-value-bind (res err)
        (block test-suite
          (handler-bind ((error (lambda (c)
                                  ;; とりあえず捕捉してfailにする
                                  (return-from test-suite (values :fail c)))))
            (funcall fn)
            (values :pass nil)))
      (%make-result :name name
                    :doc doc
                    :fn fn
                    :result res
                    :error err))))

(defun run-tests (&rest tests &key run-parallel-p)
  (if run-parallel-p
      (lparallel:pmapcar #'run-test tests)
      (mapcar #'run-test tests)))

#+nil
(defun test-example ()
  (labels ((fact (n)
             (if (zerop n)
                 1
                 (* n (fact (1- n))))))
    (run-tests
     (make-test (:name "Factorial"
                 :doc "Testing factorial")
       (ok (= (fact 5) 120))
       (ok (= (fact 3) 6))
       (ok (= (fact 0) 1))))))

;; macros

(defmacro ok (expr)
  `(assert ,expr))

(defmacro ng (expr)
  "Returns :pass if EXPR returns nil, if not :fail."
  `(assert (not ,expr)))

(defmacro pass (expr)
  "Always returns :pass"
  (declare (ignore expr)))

(defun fail (expr)
  "Always returns :fail"
  (declare (ignore expr)))

(defun skip (expr)
  "Always returns :skip"
  (declare (ignore expr))
  :skip)

(defun is (expr expected &key (test #'equal))
  "Returns :pass if EXPR evaluated is equal to EXPECTED, if not :fail."
  (if (funcall test (eval expr) expected)
      :pass
      :fail))

(defun isnt (expr expected &key (test #'equal))
  "Returns :pass if EXPR evaluated is equal to EXPECTED, if not :fail."
  (if (funcall test (eval expr) expected)
      :fail
      :pass))
