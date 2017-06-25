;;;; CLSQL functions for DB backend.

(in-package :com.moltencopper.db)

;(declaim (optimize debug))

;;; Handled threaded access
(defvar *db-lock* (sb-thread:make-mutex :name "db lock"))

(defun connect-to-mocu ()
  "Connect to rlg database, set some options."
  ;; mac socket interface uses utf-8
  #+darwin (clsql:connect '("localhost" "mocu" "jonathon" "none")
		    :database-type :postgresql-socket :if-exists :old)
  #-darwin (clsql:connect '("localhost" "mocu" "jonathon" "none")
		    :database-type :postgresql :if-exists :old)
  #+db-debug (format t "; --> Connected to db.~%"))

(defun disconnect-from-mocu ()
  "Disconnect from database."
  (clsql:disconnect))

(clsql:locally-enable-sql-reader-syntax)

(defun get-mocu-user (username)
  "Get a moltencopper user."
  (with-mutex (*db-lock*)
    (caar
     (clsql:select 'mcuser
		   :where
		   [= [slot-value 'mcuser 'username] username]))))

(defun get-mocu-users ()
  "Get moltencopper users."
  (with-mutex (*db-lock*)
    (clsql:select 'mcuser :flatp t :refresh t)))

#+darwin (clsql:locally-disable-sql-reader-syntax)
