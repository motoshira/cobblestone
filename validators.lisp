(cl:in-package #:cl-user)
(defpackage #:cobblestone/validators
  (:use #:cl #:cl-ppcre)
  (:shadow #:integer #:string)
  (:export #:uuid
           #:not-nil
           #:integer
           #:integer-str))

(in-package #:cobblestone/validators)

(defun string ()
  "Validate if a value is a string."
  `(:validate ,#'stringp
    :message ,(lambda (key)
                (format nil "~a must be a string" key))))

(defun integer ()
  "Validate if a value is an integer."
  `(:validate ,#'integerp
    :message ,(lambda (key)
                (format nil "~a must be an integer" key))))

(defun integer-str ()
  "Validate if a value is an integer or a string of an integer."
  `(:validate ,(lambda (s)
                 (or (integerp s)
                     (and (stringp s)
                          (ppcre:scan "[0-9]+" s))))
    :message ,(lambda (key)
                (format nil "~a must be an integer" key))
    :coerce ,(lambda (s)
               (if (integerp s)
                   s
                   (parse-integer s)))))

(defun not-nil ()
  `(:validate ,(lambda (s) (not (null s)))
    :message ,(lambda (key)
                (format nil "~a cannot be nil" key))))

(defun uuid ()
  "Validate if a string is a valid UUID. Note that it assumes parameter is a string."
  `(:validate ,(lambda (s)
                 (ppcre:scan "^([0-9A-F]{8})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{12})$" s))
    :message "Invalid UUID format"))
