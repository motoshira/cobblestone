(defpackage cobblestone/report
  (:nicknames #:cb/report)
  (:import-from #:cb/test)
  (:use :cl))

(in-package #:cb/report)

(defun str (&rest args)
  (with-output-to-string (s)
    (dolist (arg args)
      (when arg
        (princ arg s)))))

(defun make-failure-report (result)
  (with-slots
        ((name cb/test::name)
         (doc cb/test::doc)
         (fn cb/test::fn)
         (err cb/test::error))
      result
    (str
     "Failed test-case" #\Newline
     ;; Name
     "    Name: " name #\Newline
     ;; Description
     (when doc
       (str "    Documentation: " doc #\Newline))
     ;; Error
     "    Error: " err #\Newline)))

(defun report-results (results &optional (stream *error-output*))
  (let* ((fails (remove-if-not (lambda (result)
                                 (eq (cb/test::result-result result)
                                     :fail))
                               results))
         (skips (remove-if-not (lambda (result)
                                 (eq (cb/test::result-result result)
                                     :skip))
                               results))
         (fail-cnt (length fails))
         (skip-cnt (length skips))
         (pass-cnt (- (length results)
                      fail-cnt
                      skip-cnt))
         (res (apply #'str
                     "Test result:" #\Newline
                     "    Success: " pass-cnt #\Newline
                     "    Failure: " fail-cnt #\Newline
                     "    Skip: " skip-cnt #\Newline
                     #\Newline
                     (mapcar (lambda (fail)
                               (make-failure-report fail))
                             fails))))
    (princ res stream)))
