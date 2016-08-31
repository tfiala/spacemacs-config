(setq emacs-app-bundle-packages
      '(magit
        (magit :location elpa)))

(defun emacs-app-bundle/post-init-magit ()
    ;; We can't assume that the 'f' package will be loaded
    ;; at this point, since another layer or the user may
    ;; have excluded it from loading.  We wrap this here
    ;; so that, in the event it is excluded, we essentially
    ;; do nothing.
    (with-eval-after-load 'magit
      (emacs-app-bundle/set-emacsclient-path-as-needed)))

(defun emacs-app-bundle/set-emacsclient-path-as-needed ()
  ;; We only care when on macOS and the Emacs executable
  ;; is within a directory that ends in .app.
  ;; (message "Running set-meacsclient-path-as-needed.")
  (when (and (eq system-type 'darwin)
             (string-match ".app/" invocation-directory))
    ;; (message "We're on macOS and Emacs appears to be an app bundle.")
    ;; At https://emacsformacosx.com, the Emacs.app bundles
    ;; have an Emacs binary with a name like
    ;; Emacs-x86_64-10_9.  The relevant emacsclient is
    ;; then in a directory below the Emacs binary with
    ;; a name like bin-x86_64-10_9.
    (when (string-match "^Emacs\\(.+\\)$" invocation-name)
      ;; (message "We have pulled off the following arch path component: %s" (match-string 1 invocation-name))
      (let ((emacsclient-path (concat invocation-directory "bin" (match-string 1 invocation-name) "/emacsclient")))
        ;; If the emacsclient path we built exists, we will tell
        ;; magit about it so it knows how to call back into our Emacs
        ;; when calling out to git commands that need an editor.
        (setq with-editor-emacsclient-executable emacsclient-path)
        (message "Found Emacs.app emacsclient here: %s" emacsclient-path)))))
