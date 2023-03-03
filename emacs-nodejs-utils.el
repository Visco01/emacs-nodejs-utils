;;; emacs-nodejs-utils.el --- package for NodeJS support -*- lexical-binding: t; -*-

;;; Commentary:
;;; This package provides some functions to integrate NodeJS development in Emacs

;;; Code:

(require 'projectile)

(defun nodejs-open ()
  "Open NodeJS server on MacOS default browser"
  (interactive)
  (let ((url "http://localhost:8000/"))
    (start-nodejs-current-buffer)
    (browse-url-default-macosx-browser url)))

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


(provide 'emacs-nodejs-utils)
;;; emacs-nodejs-utils.el ends here
