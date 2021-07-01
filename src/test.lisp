(defpackage :cobblestone/test
  (:nicknames #:cb/test)
  (:use #:cl)
  (:export #:test-name
           #:test-doc
           #:test-fn))

(in-package #:cobblestone/test)


(defstruct (test-case (:constructor %make-test)
                      (:conc-name test-))
  (name nil :type (or null string))
  (fn nil :type function)
  (doc nil :type (or null string)))

(defmacro make-test ((&key name doc) &body body)
  `(%make-test
    ,@(when name
        `(:name ,name))
    ,@(when doc
        `(:doc ,doc))
    :fn (lambda ()
          ,@body)))

(defstruct (result (:constructor %%make-result))
  (doc "" :type (or null string))
  (fn nil :type function)
  (result nil :type (member :pass :fail :skip)))

(defun run-test (test-case)
  (%%make-result :doc (test-doc test)
                 :fn (test-fn test)
                 :result result-key))
