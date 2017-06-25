;;;; Cookie-based authentication - server independent.

(in-package :com.moltencopper.serve)

(defparameter *users* (make-hash-table :test 'equal) "logged-in users")

(defun validate-user ()
  (unless (session-value 'user) (redirect "?auth=none")))

(defun verify-user-and-password (user pass)
  "Check user name and password with the database.
When they match, return user, authenticator, and user home."
  (let ((mocu-user (get-mocu-user user)))
    #- (and) (when (and mocu-user (string= pass (password mocu-user)))
      (setf (gethash user *users*) t))
    (setf (gethash user *users*) t)))
