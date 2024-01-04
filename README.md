# Cobblestone

Structural validation library for Common Lisp

## Description

Cobblestone is a structural validation library for Common Lisp, inspired by [funcool/struct](https://github.com/funcool/struct).

It provides a way to define a validator for association list and validate it.

This software is in alpha stage. The API may change in the future.

## Usage

 ```lisp

 (use-package :cobblestone)

(defparameter *test-validator-spec*
  `(("id"
     (:validate ,#'integerp
      :message "id must be a integer"))
    ("name"
     (:validate ,#'stringp
      :message "name must be a string"))))

(defparameter *test-validator*
  (compile-validator *test-validator-spec*
                     :key-test #'equal
                     :required-keys '("id" "name")
                     :required-message (lambda (key)
                                         (format nil "~a is required" key))))

;; validate returns two values, the first is a error alist, the second is a result alist.

(validate *test-validator* '(("id" . 1) ("name" . "foo")))
;; => NIL, (("id" . 1) ("name" . "foo"))

(validate *test-validator* '(("id" . 1)))
;; => (("name" . "name is required")), (("id" . 1))

(validate *test-validator* '(("id" . "1") ("name" . "foo")))
;; => (("id" . "id must be a integer")), (("name" . "foo"))
```

## Author

* Kohei Hosoki (koubee473@gmail.com)

## Copyright

Copyright (c) 2023 Kohei Hosoki (koubee473@gmail.com)

# License

MIT
