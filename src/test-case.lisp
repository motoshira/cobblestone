(defpackage :cobblestone/test-case
  (:nicknames #:cb/test-case)
  (:use #:cl)
  (:export #:test-name
           #:test-doc
           #:test-fn))

(in-package #:cobblestone/test-case)


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
