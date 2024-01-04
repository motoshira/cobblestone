(defpackage cobblestone/main
  (:nicknames #:cobblestone)
  (:use #:cl)
  (:export #:compile-validator
           #:validate))

(in-package cobblestone/main)

(defparameter *default-error-message* "validation error")

(defun %make-message-fn (message)
  (etypecase message
    (string (constantly message))
    (function message)
    (null (constantly *default-error-message*))))

(defstruct (validator (:constructor %make-validator))
  (validate nil :type function)
  (coerce nil :type function)
  (message nil :type function))

(defun %make-validator-from-spec (spec key)
  (destructuring-bind (&key validate coerce message &allow-other-keys) spec
    (let ((validate (or validate (constantly t)))
          (coerce (or coerce #'identity))
          (message (%make-message-fn message )))
      (%make-validator :validate validate
                       :coerce coerce
                       :message message))))

(defstruct (compiled-alist-validator (:constructor %make-cav)
                                     (:conc-name %cav-))
  (keys nil :type list)
  (required-keys nil :type list)
  (required-message nil :type function)
  (validation-fn-by-key nil :type hash-table)
  (key-test nil :type function))

(defun compile-validator (schema &rest options &key (key-test #'equal) required-keys required-message)
  (declare (ignore options))
  (let ((v-fn-by-key (make-hash-table :test key-test)))
    (dolist (kvs schema)
      (destructuring-bind (key &rest vs) kvs
        (let* ((vs (loop for spec in vs
                         collect (%make-validator-from-spec spec key)))
               (validate-fn (lambda (value)
                              (block validate
                                (dolist (v vs)
                                  (unless (funcall (validator-validate v) value)
                                    (return-from validate
                                      (values (funcall (validator-message v) key)
                                              nil)))
                                  (setf value (funcall (validator-coerce v) value)))
                                (values nil
                                        value)))))
          (setf (gethash key v-fn-by-key) validate-fn))))
    (%make-cav :keys (mapcar #'car schema)
               :required-keys (reverse required-keys)
               :required-message (%make-message-fn required-message)
               :validation-fn-by-key v-fn-by-key
               :key-test key-test)))

(defun validate (validator alist)
  "Perform validation on ALIST using VALIDATOR. OPTIONS is a plist"
  (with-accessors ((keys %cav-keys)
                   (required-keys %cav-required-keys)
                   (required-message %cav-required-message)
                   (v-fn-by-key %cav-validation-fn-by-key)
                   (key-test %cav-key-test)) validator
    (let ((res nil)
          (errors nil)
          (required-keys-table (make-hash-table :test key-test)))
      (dolist (key required-keys)
        (setf (gethash key required-keys-table) t))
      (loop for (key . value) in alist do
        (multiple-value-bind (v-fn found) (gethash key v-fn-by-key)
          (when found
            (remhash key required-keys-table)
            (multiple-value-bind (error v) (funcall v-fn value)
              (if error
                  (push (cons key error) errors)
                  (push (cons key v) res))))))
      (dolist (missing-key (reverse required-keys))
        (when (gethash missing-key required-keys-table)
          (push (cons missing-key (funcall required-message missing-key))
                errors)))
      (values (reverse errors)
              (reverse res)))))
