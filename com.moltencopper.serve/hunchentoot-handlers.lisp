;;;; Hunchentoot handlers.

(in-package :com.moltencopper.serve)

;(declaim (optimize debug))

(defun show-login-bar ()
  (with-html-output-to-string (s)
    (:div :id "loginform" :style "display:none;"
	  (:form :method "post" :action "login"
		 (:label :for "user" "Username")
		 (:input :type "text" :name "user")
		 (:label :for "pass" "Password")
		 (:input :type "password" :name "pass")
		 (:input :type "submit" :value "Login")))))

(defun show-banner ()
  (with-html-output-to-string (s nil :indent t)
    (:div :id "banner"
	  (:span :class "bbutton"
		 (:a :href "#" :onclick "showLogin();" "login"))
	  (:span :class "btext" "Molten Copper"))))

(defun show-toolbar (auth)
  (declare (ignorable auth))
  (with-html-output-to-string (s)
    (:div :id "menubar" :class "cleanframe"
	  (:ul
	   (:li (:a :href "/" "Home"))
	   (:li (:a :href "z" "Z"))
	   (:li (:a :href "users" "Users"))))))

;;; Basic non-authenticated handlers -------------------------------------------

(define-easy-handler
    (handle-home :uri "/")
    (auth)
  (format t "Auth: ~S~%" auth)
  (with-html-output (s (send-headers) :prologue t :indent t)
    (:html :xmlns "http://www.w3.org/1999/xhtml" :lang "en"
	   (:head
	    (:title "Molten Copper Home")
	    (:meta :http-equiv "Content-Type" :content "text/html")
	    (:link :rel "stylesheet" :href "/style/main.css" :type "text/css")
	    (:script :src "js/prototype.js" :type "text/javascript")
	    (:script :src "js/lib.js" :type "text/javascript")
	    (:script :src "js/stuff.js" :type "text/javascript"))
	   (:body
	    (str (show-login-bar))
	    (str (show-banner))
	    (str (show-toolbar auth))
	    (:div :id "contentpane-2" :class "cleanframe"
		  (:table :border "0"
			  (:tr (:th "a") (:th "b") (:th "c"))
			  (:tr (:td "0") (:td "1") (:td "2"))
			  (:tr (:td "0") (:td "1") (:td "2")))
		  (:ul (:li "1") (:li "2") (:li "3"))
		  (:p "Here is an example of some content.")
		  (:p "Here is another paragraph we want to show."))))))

(defun handle-logout ()
  "Clear session values, optionally remove user from hash, and redirect."
  (delete-session-value 'exp)
  (delete-session-value 'user)
  (delete-session-value 'digest)
  ;; hash?
  (redirect "/"))

;;; Authenticated handlers -----------------------------------------------------
;;; Even though these look like static file dispatchers,
;;; they include the authentication wrapper to ensure the user is logged in
;;; before being able to access them.  Most of them serve the main page of
;;; their respective applications.

(defun handle-z ()
  "Test CL-WHO."
  (validate-user)
  (let ((links '(("http://apple.com" . "Apple")
		 ("http://apple.com" . "Apple")
		 ("http://apple.com" . "Apple"))))
    (with-html-output (s (send-headers) :prologue t :indent t)
      (htm
       (:html :xmlns "http://www.w3.org/1999/xhtml"
	      :lang "en"
	      (:head
	       (:title "My test page")
	       (:meta :http-equiv "Content-Type" :content "text/html")
	       (:link :rel "stylesheet" :href "/style/main.css" :type "text/css"))
	      (:body
	       (str (show-banner))
	       (str (show-toolbar nil))
	       (:div :id "contentpane-2" :class "cleanframe"
		     (loop for (link . title) in links do
			  (htm (:a :href link (str title)) :br))
		     (:select :id "month"
			      (:option "jan")
			      (:option "feb"))
		     :br
		     (:input :type "checkbox" :id "cb" "Some text")
		     :br
		     (:input :type "radio" :name "group1" "Item 1")
		     (:input :type "radio" :name "group1" "Item 2")
		     (:input :type "radio" :name "group1" "Item 3"))
	       (:div :id "footer" :style "clear:both"
		     "Copyright &copy; 2007 molten copper")))))))

(defun handle-users ()
  "Show users table."
  (validate-user)
  (with-html-output (s (send-headers) :prologue t :indent t)
    (htm
     (:html
      (:head
       (:title "Users")
       (:meta :http-equiv "Content-Type" :content "text/html")
       (:link :rel "stylesheet" :href "/style/main.css" :type "text/css"))
      (:body
       (str (show-banner))
       (str (show-toolbar nil))
       (:div :id "contentpane-2" :class "cleanframe"
	     (:table :border "0"
		     (:tr
		      (:th "username")
		      (:th "password"))
		     (loop for user in (get-mocu-users) do
			  (htm
			   (:tr
			    (:td (str (username user)))
			    (:td (str (password user)))))))))))))

(defparameter *my-table* (list (list :cols
				     (list (list :content 1)
					   (list :content 1)))
			       (list :cols
				     (list (list :content 1)
					   (list :content 1)))))

(defun handle-y ()
  "Show page from template."
  (let* ((rows (loop for i below 49 by 7
		  collect (list :cols
				(loop for j from i below (+ i 7)
				   for string = (format nil "~R" j)
				   collect (list :content string
						 :colorful-style (oddp j)))))))
    (format t "Rows: ~A~%" rows)
    (html-template:fill-and-print-template (pathname "wwwroot/xhtml/y.xhtml")
					   (list
					    :a "Hey!"
					    ;:rows rows
					    :testing t
					    :rows *my-table*
					    )
					   :stream (send-headers))))

;;; Web server entry points ----------------------------------------------------

(defun mocu-web-start ()
  "Start the server."
  (setf (log-file) "logs/serverlog")
  (format t "; --> Starting...~%")
  (setf *mocu-server* (hunchentoot:start-server :port +server-port+))
  (format t "; --> Ready!~%"))

(defun mocu-web-stop ()
  "Stop rlg web application.
Stop Araneida and disconnect from the database."
  (restart-case
      (hunchentoot:stop-server *mocu-server*)
    (ignore-simple-error (c)
      (format t "STOP-LISTENING error ignored: ~A~%" (type-of c)))
    (ignore-unbound-slot (c)
      (format t "STOP-LISTENING error ignored: ~A~%" (type-of c)))
    (ignore-shutdown-condition (c)
      (format t "STOP-LISTENING error ignored: ~A~%" (type-of c))))
  (format t "; --> Stopped.~%"))

;;; Initialize dispatch table --------------------------------------------------

(setf *dispatch-table*
      (nconc				; Remember: like @ splice

       ;; simple handlers (mostly for forms)
       (list 'dispatch-easy-handlers)

       ;; folders - need trailing slash
       (mapcar (lambda (args)
		 (apply #'create-folder-dispatcher-and-handler args))
	       `(;; folders for content and other web files
		 ("/images/" "wwwroot/images/")
		 ("/style/" "wwwroot/style/")
		 ("/js/" "wwwroot/js/")))

       ;; prefix handlers - no trailing slash
       (mapcar (lambda (args)
		 (apply #'create-prefix-dispatcher args))
	       `(;; web application root handlers
		 (,+url-logout+ handle-logout)
		 (,+url-z+ handle-z)
		 (,+url-users+ handle-users)
		 (,+url-y+ handle-y)))

       ;; everything else
       (list
	#'default-dispatcher)))
