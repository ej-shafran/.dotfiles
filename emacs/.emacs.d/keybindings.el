;; Keybindings

(defmacro todo (message)
  `(lambda ()
    (interactive)
    (error "TODO: %s" ,message)))

(evil-define-key 'normal 'global
  (kbd "C-l") 'evil-window-right
  (kbd "C-k") 'evil-window-up
  (kbd "C-j") 'evil-window-down
  (kbd "C-h") 'evil-window-left

  (kbd "gcc") (lambda (lines)
		(interactive "p")
		(comment-line lines)
		(evil-previous-line))
  )

(evil-define-key 'visual 'global
  (kbd "gc") 'comment-or-uncomment-region
  )

;; Buffer

(evil-define-key 'normal 'global
  (kbd "<leader>bb") 'ivy-switch-buffer
  (kbd "<leader>bl") 'evil-switch-to-windows-last-buffer
  (kbd "<leader>bo") (todo "Kill other buffers")
  (kbd "<leader>bq") 'kill-buffer
  (kbd "]b") (lambda () (next-buffer 1))
  (kbd "[b") (lambda () (next-buffer -1))
  )

;; Code

(evil-define-key 'normal 'global
  (kbd "<leader>cc") 'compile
  (kbd "<leader>ch") (todo "Compile without opening buffer")
  (kbd "<leader>cC") 'recompile
  (kbd "<leader>cf") (todo "Format code")
  (kbd "<leader>cq") (todo "Quickfix alternative")
  (kbd "<leader>ca") (todo "Code actions")
  (kbd "<leader>ce") (todo "Diagnostics")
  (kbd "<leader>cD") (todo "LSP")
  (kbd "<leader>cx") 'eval-last-sexp
  (kbd "<leader>cX") 'eval-buffer
  (kbd "[e") 'previous-error
  (kbd "]e") 'next-error
  )

;; Debug

;; TODO

;; Files

(evil-define-key 'normal 'global
  (kbd "<leader>ff") 'find-file
  (kbd "<leader>fg") 'project-find-file
  (kbd "<leader>fr") 'recentf-open-files
  (kbd "<leader>fl") (todo "Harpoon alternative")
  )

;; Git

(evil-define-key 'normal 'global
  (kbd "<leader>gb") 'magit-branch
  (kbd "<leader>gd") 'magit-diff
  (kbd "<leader>gC") 'magit-commit
  (kbd "<leader>gf") (todo "Floating window for Magit")
  (kbd "<leader>gg") 'magit-status
  (kbd "<leader>gh") 'blamer-show-commit-info
  (kbd "<leader>ga") 'git-gutter:stage-hunk
  (kbd "[c") 'git-gutter:previous-hunk
  (kbd "]c") 'git-gutter:next-hunk
  )

;; Help
(evil-define-key 'normal 'global
  (kbd "<leader>h C-a") 'about-emacs
  (kbd "<leader>h C-c") 'describe-copying
  (kbd "<leader>h C-d") 'view-emacs-debugging
  (kbd "<leader>h C-e") 'view-external-packages
  (kbd "<leader>h C-f") 'view-emacs-FAQ
  (kbd "<leader>h C-h") 'help-for-help
  (kbd "<leader>h RET") 'view-order-manuals
  (kbd "<leader>h C-n") 'view-emacs-news
  (kbd "<leader>h C-o") 'describe-distribution
  (kbd "<leader>h C-p") 'view-emacs-problems
  (kbd "<leader>h C-s") 'search-forward-help-for-help
  (kbd "<leader>h C-t") 'view-emacs-todo
  (kbd "<leader>h C-w") 'describe-no-warranty
  (kbd "<leader>h C-\\") 'describe-input-method
  (kbd "<leader>h.") 'display-local-help
  (kbd "<leader>h?") 'help-for-help
  (kbd "<leader>hC") 'describe-coding-system
  (kbd "<leader>hF") 'Info-goto-emacs-command-node
  (kbd "<leader>hI") 'describe-input-method
  (kbd "<leader>hK") 'Info-goto-emacs-key-command-node
  (kbd "<leader>hL") 'describe-language-environment
  (kbd "<leader>hP") 'describe-package
  (kbd "<leader>hS") 'info-lookup-symbol
  (kbd "<leader>ha") 'apropos-command
  (kbd "<leader>hb") 'describe-bindings
  (kbd "<leader>hc") 'describe-key-briefly
  (kbd "<leader>hd") 'apropos-documentation
  (kbd "<leader>he") 'view-echo-area-messages
  (kbd "<leader>hf") 'describe-function
  (kbd "<leader>hg") 'describe-gnu-project
  (kbd "<leader>hh") 'view-hello-file
  (kbd "<leader>hi") 'info
  (kbd "<leader>hk") 'describe-key
  (kbd "<leader>hl") 'view-lossage
  (kbd "<leader>hm") 'describe-mode
  (kbd "<leader>hn") 'view-emacs-news
  (kbd "<leader>ho") 'describe-symbol
  (kbd "<leader>hp") 'finder-by-keyword
  (kbd "<leader>hq") 'help-quit
  (kbd "<leader>hr") 'info-emacs-manual
  (kbd "<leader>hs") 'describe-syntax
  (kbd "<leader>ht") 'help-with-tutorial
  (kbd "<leader>hv") 'describe-variable
  (kbd "<leader>hw") 'where-is
  (kbd "<leader>h<f1>") 'help-for-help
  (kbd "<leader>h<help>") 'help-for-help
  (kbd "<leader>h4 i") 'info-other-window
  )

;; Input

;; TODO

;; Open

(evil-define-key 'normal 'global
  (kbd "<leader>o-") 'dired-jump
  )

;; Plugin

;; TODO

;; Quit

(evil-define-key 'normal 'global
  (kbd "<leader>qq") 'save-buffers-kill-emacs
  (kbd "<leader>qQ") 'kill-emacs
  )

;; Search

(defun grep-func (dir regexp)
  "Search for REGEXP in DIR using rgrep."
  (grep (concat "rgrep --color -nH --null \"" regexp "\" " dir)))

(defun grep-for-prompt (dir prompt)
  "Search in DIR using rgrep for regex returned by prompting with PROMPT in the minibuffer."
  (let ((regexp (read-from-minibuffer prompt)))
    (grep-func dir regexp)))

(evil-define-key 'normal 'global
  (kbd "<leader>sb") 'search-forward
  (kbd "<leader>sc") (lambda ()
		       (interactive)
		       (grep-for-prompt config-dir "Search in config directory: "))
  (kbd "<leader>sd") (lambda ()
		       (interactive)
		       (grep-for-prompt default-directory "Search in current directory: "))
  (kbd "<leader>ss") (lambda ()
		       (interactive)
		       (grep-func default-directory (thing-at-point 'word)))
  )

;; Toggle

(evil-define-key 'normal 'global
  (kbd "<leader>tb") 'blamer-mode
  (kbd "<leader>tc") (todo "Code context")
  (kbd "<leader>tl") 'display-line-numbers-mode
  (kbd "<leader>ts") 'flyspell-mode
  (kbd "<leader>tz") (todo "Zen mode")
  (kbd "<leader>tC") (todo "Cursorcolumn")
  (kbd "<leader>tt") 'eshell
  )

;; Window

(evil-define-key 'normal 'global
 (kbd "<leader>ws") (kbd "C-w s")
 (kbd "<leader>wv") (kbd "C-w v")
 (kbd "<leader>ww") (kbd "C-w w")
 (kbd "<leader>wq") (kbd "C-w q")
 (kbd "<leader>wo") (kbd "C-w o")
 (kbd "<leader>wT") (kbd "C-w T")
 (kbd "<leader>wx") (kbd "C-w x")
 (kbd "<leader>w-") (kbd "C-w -")
 (kbd "<leader>w+") (kbd "C-w +")
 (kbd "<leader>w<lt>") (kbd "C-w <lt>")
 (kbd "<leader>w>") (kbd "C-w >")
 (kbd "<leader>w|") (kbd "C-w |")
 (kbd "<leader>w_") (kbd "C-w _")
 (kbd "<leader>w,") (kbd "C-w =")
  )
