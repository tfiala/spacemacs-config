(setq emacs-app-bundle-packages
      '(magit
        (magit :location elpa)))

(defun emacs-app-bundle/post-init-magit ()
  (emacs-app-bundle/set-emacsclient-path-as-needed))

(defun emacs-app-bundle/set-emacsclient-path-as-needed ()
  ;; We only care when on macOS and the Emacs executable
  ;; is within a directory that ends in .app.
  (when (and (eq system-type 'darwin)
             (string-match ".app/" invocation-directory))
    ;; At https://emacsformacosx.com, the Emacs.app bundles
    ;; have an Emacs binary with a name like
    ;; Emacs-x86_64-10_9.  The relevant emacsclient is
    ;; then in a directory below the Emacs binary with
    ;; a name like bin-x86_64-10_9.
    (when (string-match "^Emacs\\(.+\\)$" invocation-name)
      (let ((emacsclient-path (concat invocation-directory "bin" (match-string 1 invocation-name) "/emacsclient")))
        ;; If the emacsclient path we built exists, we will tell
        ;; magit about it so it knows how to call back into our Emacs
        ;; when calling out to git commands that need an editor.
        (when (file-exists-p emacsclient-path)
          (setq with-editor-emacsclient-executable emacsclient-path)
          (message "Found Emacs.app emacsclient here: %s" emacsclient-path))))))
