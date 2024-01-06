(cl:in-package #:cl-user)
(defpackage #:cobblestone/validators
  (:use #:cl #:cl-ppcre)
  (:export #:uuid))

(in-package #:cobblestone/validators)

(defun uuid? (s)
  (ppcre:scan "([0-9A-F]{8})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{12})" s))

(defun uuid ()
  "Validate if a string is a valid UUID. Note that it assumes parameter is a string."
  `(:validate ,(lambda (s)
                 (ppcre:scan "^([0-9A-F]{8})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{4})-([0-9A-F]{12})$" s))
    :message "Invalid UUID format"))
