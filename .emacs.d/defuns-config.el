;; --------------------
;; -- Global defuns ---
;; --------------------

(defun next5()
  (interactive)
  (next-line 5))

(defun prev5()
  (interactive)
  (previous-line 5))

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(defun back-window ()
  (interactive)
  (other-window -1))

(defun whitespace-cleanup-all ()
  (interactive)
  (setq indent-tab-mode nil)
  (whitespace-cleanup))

(defun whitespace-clean-and-compile ()
  "Cleans up whitespace and compiles. The compile-command is a
varies with the active mode."
  (interactive)
  (whitespace-cleanup-all)
  (compile compile-command))
