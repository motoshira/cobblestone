(defpackage :cobblestone/test-case
  (:nickname #:cb/test-case)
  (:use #:cl))

(in-package #:cobblestone/test-case)

(deftype test-type () '(member :ok :ng :is :isnt :pass :fail :expand :condition))

(defstruct (test-case (:constructor %make-test))
  (expr nil :type cons)
  (expect nil :type t)
  (type :ok :type test-type))
