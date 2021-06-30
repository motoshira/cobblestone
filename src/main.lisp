(defpackage #:cobblestone/main
  (:nicknames #:cobblestone
              #:cb)
  (:use #:cl))

(in-package #:cobblestone/main)

;; TODO:
;;  Write essential implementation first, then introduce structure object.

(defun ok (expr)
  "Returns :pass if EXPR returns t, if not :fail."
  (if (eval expr)
      :pass
      :fail))

(defun ng (expr)
  "Returns :pass if EXPR returns nil, if not :fail."
  (if (not (eval expr))
      :pass
      :fail))

(defun pass (expr)
  "Always returns :pass"
  (declare (ignore expr))
  :pass)

(defun fail (expr)
  "Always returns :fail"
  (declare (ignore expr))
  :fail)

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

#+nil
(defun run-test (test)
  (declare (test-case test))
  (the test-result)
  nil)


(defun run-tests (&rest test-casess)
  (mapcar #'run-test tests))
