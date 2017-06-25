(in-package :cl-user)

;;; Errors to ignore during shutdown.

(defun ignore-simple-error (c)
  (invoke-restart 'com.moltencopper.serve::ignore-simple-error c))

(defun ignore-unbound-slot (c)
  (invoke-restart 'com.moltencopper.serve::ignore-unbound-slot c))

(defun ignore-shutdown-condition (c)
  (invoke-restart 'com.moltencopper.serve::ignore-shutdown-condition c))

(defun mocu-stop ()
  "Stop mocu application (web server and db)."
  (handler-bind ((simple-error #'ignore-simple-error)
		 (unbound-slot #'ignore-unbound-slot)
		 (simple-error #'ignore-shutdown-condition))
    (com.moltencopper.serve:mocu-web-stop))
  
  (handler-case (com.moltencopper.db:disconnect-from-mocu)
    (simple-error (e) (format t "DISCONNECT error ignored: ~A~%" e))))

(defun mocu-start ()
  "Main system startup."
  (mocu-stop)
  (com.moltencopper.db:connect-to-mocu)
  (sb-thread:make-thread 'com.moltencopper.serve:mocu-web-start))

(mocu-start)
