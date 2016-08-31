;; This package hooks up gtags keybindings to python mode.
(setq python-gtags-packages
      '(helm-gtags
        python))

(defun python-gtags/post-init-python ()
  ;; Only do this when (if) helm-gtags is loaded.
  (with-eval-after-load 'helm-gtags
    (spacemacs/helm-gtags-define-keys-for-mode 'python-mode)))
