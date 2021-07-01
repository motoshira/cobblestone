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

;; tODO: fixture

(defmacro make-test ((&key name doc) &body body)
  `(%make-test
    ,@(when name
        `(:name ,name))
    ,@(when doc
        `(:doc ,doc))
    :fn (lambda ()
          ,@body)))

(defstruct (result (:constructor %make-result))
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
      (%make-result :doc doc
                    :fn fn
                    :result res
                    :error err))))
