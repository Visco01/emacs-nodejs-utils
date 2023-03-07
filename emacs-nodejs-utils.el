;;; emacs-nodejs-utils.el --- package for NodeJS support -*- lexical-binding: t; -*-

;;; Commentary:
;;; This package provides some functions to integrate NodeJS development in Emacs

;;; Code:
(require 'projectile)

(defcustom diamond-nodejs-keymap-prefix "C-c C-n"
  "The prefix for nodejs-mode key bindings."
  :type 'string
  :group 'diamond-nodejs)

(defcustom diamond-nodejs-server-file-name "index.js"
  "The prefix for nodejs-mode key bindings."
  :type 'string
  :group 'diamond-nodejs)

(defcustom diamond-nodejs-server-on-save t
  "When t, automatically power up the server on save."
  :type 'boolean
  :group 'diamond-nodejs)

(defcustom diamond-nodejs-server-port 8000
  "When t, automatically power up the server on save."
  :type 'integer
  :group 'diamond-nodejs)

(defcustom diamond-nodejs-host-name "localhost"
  "When t, automatically power up the server on save."
  :type 'string
  :group 'diamond-nodejs)

(defcustom diamond-nodejs-http-encryption nil
  "When t, automatically power up the server on save."
  :type 'boolean
  :group 'diamond-nodejs)

(defun check-projectile ()
  "Check if current buffer is in a known project"
  (if (eq (projectile-project-name) "-")
      nil
    t))

(defun nodejs-open ()
  "Open NodeJS server on MacOS default browser"
  (interactive)
  (start-nodejs-current-buffer)
  (browse-url-default-browser
   ;; Url
   (concat (funcall (lambda ()
		      (if diamond-nodejs-http-encryption
			  "https"
			"http")))
	   "://"
	   diamond-nodejs-host-name
	   ":"
	   (number-to-string diamond-nodejs-server-port))))

(defun nodejs-kill ()
  "Kill NodeJS server"
  (interactive)
  (let ((buffname "*Async Shell Command*"))
    (if (bufferp (get-buffer buffname))
        (let ((kill-buffer-query-functions nil))
	  (kill-buffer buffname)))))

(defun start-nodejs-project-root ()
  "Start NodeJS server asynchronous on project root"
  (let ((abuff-name "*Async Shell Command*"))
    (unless (not (bufferp (get-buffer abuff-name)))
      (save-current-buffer
        (kill-buffer abuff-name))))
  (projectile-run-async-shell-command-in-root "node index.js"))

(defun start-nodejs-current-buffer ()
  "Start NodeJS server asynchronous on the current buffer"
  (interactive)
  (let ((node-buff-name "*Async Shell Command*"))
    (if (bufferp (get-buffer node-buff-name))
	(progn
	  (save-current-buffer)
	  (kill-buffer node-buff-name)))
    (async-shell-command (concat "node "
				 (buffer-file-name (current-buffer))))))

(defun nodejs-start-server ()
  "Start the fucking server"
  (interactive)
  (nodejs-kill)
  (if (projectile-project-buffer-p 0000 PROJECT-ROOT)
      )
  )

(defun nodejs-mode-run ()
  "Execute nodejs minor mode: kill previous nodejs server and start a new one"
  (progn
    (nodejs-kill)
    (nodejs-open)))

(defun nodejs-mode--key (key)
  (kbd (concat diamond-nodejs-keymap-prefix " " key)))

(define-minor-mode nodejs-mode
  "Toggles nodejs-mode on current buffer"
  :init-value nil ; Initial value, nil for disabled
  :global nil
  :group 'diamond-nodejs
  :lighter " nodejs-mode"
  :keymap
  (list (cons (nodejs-mode--key "o") 'nodejs-open)
	(cons (nodejs-mode--key "k") 'nodejs-kill))

  (if nodejs-mode
      (add-hook 'after-save-hook 'nodejs-mode-run)
    (remove-hook 'after-save-hook 'nodejs-mode-run)))

(provide 'emacs-nodejs-utils)
;;; emacs-nodejs-utils.el ends here
