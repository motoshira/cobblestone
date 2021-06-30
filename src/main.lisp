(defpackage #:cobblestone/main
  (:nicknames #:cobblestone
              #:cb)
  (:use #:cl))

(in-package #:cobblestone/main)

;; TODO:
;;  Write essential implementation first, then introduce structure object.

(defmacro ok (expr)
  "Returns :pass if EXPR returns t, if not :fail."
  `(if (eval ,expr)
       :pass
       :fail))

(defmacro ng (expr)
  "Returns :pass if EXPR returns nil, if not :fail."
  `(if (not (eval ,expr))
       :pass
       :fail))

(defmacro pass (expr)
  "Always returns :pass"
  (declare (ignore expr))
  :pass)

(defmacro fail (expr)
  "Always returns :fail"
  (declare (ignore expr))
  :fail)

(defmacro fail (expr)
  "Always returns :skip"
  (declare (ignore expr))
  :skip)

(defmacro is (expr expected &key (test 'equal))
  "Returns :pass if EXPR evaluated is equal to EXPECTED, if not :fail."
  `(if (,test (eval ',expr)
              ',expected)
       :pass
       :fail))

(defmacro isnt (expr expected))

#+nil
(defun run-test (test)
  (declare (test-case test))
  (the test-result)
  nil)

#+nil
(defun run-tests (&rest test-casess)
  nil)
