(defpackage #:cobblestone/main
  (:nicknames #:cobblestone
              #:cb)
  (:use #:cl))

(in-package #:cobblestone/main)

(defmacro ok (expr) nil)

(defmacro ng (expr) nil)

(defmacro pass (expr) nil)

(defmacro fail (expr) nil)

(defmacro is (expr expected) nil)

(defmacro isnt (expr expected) nil)

(defmacro is-expand (expr expected-sexp) nil)

(defmacro is-conditon (expr expected-condition) nil)

(defun run-test (test)
  (declare (test-case test))
  (the test-result)
  nil)

(defun run-tests (&rest test-casess)
  nil)
