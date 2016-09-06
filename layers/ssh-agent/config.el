;; Setup ssh-agent environment variables
(defun ssh-agent/config-filename ()
  "Return the ssh-agent config file path name."
  (concat (getenv "HOME") "/.ssh-agent.conf"))

(defun ssh-agent/read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "[;\n]" t)))

(defun ssh-agent/setenv-agent-pid (line)
  "If the given line contains a SSH_AGENT_PID={sock} line, set that in the environment of the local emacs"
  (when (string-match "^SSH_AGENT_PID=\\(.+\\)$" line)
    (setenv "SSH_AGENT_PID" (match-string 1 line))
    (message (concat "SSH_AGENT_PID=" (getenv "SSH_AGENT_PID")))))

(defun ssh-agent/setenv-authsock (line)
  "If the given line contains a SSH_AUTH_SOCK={sock} line, set that in the environment of the local emacs"
  (when (string-match "^SSH_AUTH_SOCK=\\(.+\\)$" line)
    (setenv "SSH_AUTH_SOCK" (match-string 1 line))
    (message (concat "SSH_AUTH_SOCK=" (getenv "SSH_AUTH_SOCK")))))

(defun ssh-agent-config ()
  "configure the ssh-agent environment variables into the ssh daemon process"
  (interactive)
  (when (file-exists-p (ssh-agent/config-filename))
    (message (concat "looking for ssh-agent directives in file " (ssh-agent/config-filename)))
    (let ((config-lines (ssh-agent/read-lines (ssh-agent/config-filename))))
      (mapc #'ssh-agent/setenv-authsock config-lines)
      (mapc #'ssh-agent/setenv-agent-pid config-lines))))

(ssh-agent-config)
