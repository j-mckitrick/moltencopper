;;;; Database persistence classes.

(in-package :com.moltencopper.db)

(clsql:def-view-class mcuser ()
  ((userid
    :db-kind :key
    :db-constraints :not-null
    :type integer
    :initarg :userid)
   (username
    :accessor username
    :type clsql:varchar
    :initarg :username)
   (password
    :accessor password
    :type clsql:varchar
    :initarg :password)))

