(defcustom wrangler-path nil
  "*The location of wrangler elisp directory"
  :group 'prelude-erlang
  :type 'string
  :safe 'stringp)

(when (require 'erlang-start nil t)

  (eval-after-load 'erlang-mode
    '(progn
       (flymake-mode)))

  (when (not (null wrangler-path))
    (add-to-list 'load-path wrangler-path)
    (require 'wrangler)))

(defun erlang-rebar-compile ()
  (interactive)
  (let* ((dir (or (projectile-get-project-root)
                  (file-name-directory (buffer-file-name))))
         (pref (concat "cd " dir " && "))
         (cmd (cond ((file-exists-p (expand-file-name "rebar" dir))    "./rebar compile")
                    ((executable-find "rebar")                         "rebar compile")
                    ((file-exists-p (expand-file-name "Makefile" dir)) "Makefile")
                    (t nil))))
    (if cmd
        (compilation-start (concat pref cmd))
      (call-interactively 'inferior-erlang-compile))
    ))

(add-hook 'erlang-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ;;
            ;;(make-variable-buffer-local 'projectile-project-root-files)
            ;; (setq projectile-project-root-files '("rebar.config" ".git" ".hg" ".bzr" ".projectile"))
            ;; (setq erlang-compile-function 'erlang-rebar-compile))
            ))

(provide 'prelude-erlang)
