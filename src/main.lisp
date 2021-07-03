(defpackage #:cobblestone/main
  (:nicknames #:cobblestone
              #:cb)
  (:use #:cl)
  (:import-from #:cobblestone/test
                #:make-test
                #:run-test
                #:run-tests)
  (:export #:ok
           #:ng
           #:pass
           #:fail
           #:skip
           #:fail
           #:is
           #:isnt
           #:make-test
           #:run-test
           #:run-tests))

(in-package #:cobblestone/main)

;; TODO:
;;  Write essential implementation first, then introduce structure object

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
