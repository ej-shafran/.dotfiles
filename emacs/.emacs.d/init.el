;; Constant for the path to the configuration directory
(defconst config-dir
  (cond ((boundp 'user-emacs-directory)
	 user-emacs-directory)
	((boundp 'config-directory)
	 config-directory)
	(t "~/.emacs.d/")))

;; Change `custom' file
(setq custom-file (expand-file-name "custom.el" config-dir))

;; Turn off menu bar
(menu-bar-mode -1)
;; Turn off tool bar
(tool-bar-mode -1)
;; Turn off startup screen
(setq inhibit-startup-screen t)
;; Turn on relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Setup packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'gnu-elpa-keyring-update)
  (setq package-check-signature nil)
  (package-refresh-contents)
  (package-install 'gnu-elpa-keyring-update)
  (gnu-elpa-keyring-update)
  (setq package-check-signature 'allow-unsigned))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
(eval-when-compile
  (require 'use-package))

;; Autocomplete for buffers
(use-package company
  :config
  (global-company-mode))

;; Autocomplete for minibuffers, better search, etc.
(use-package counsel
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (ivy-mode)
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

;; Magit (Git client)
(use-package magit
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

;; Git gutter
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02)
  (global-set-key (kbd "C-c g n") 'git-gutter:next-hunk)
  (global-set-key (kbd "C-c g p") 'git-gutter:previous-hunk)
  (global-set-key (kbd "C-c g s") 'git-gutter:stage-hunk)
  (global-set-key (kbd "C-c g r") 'git-gutter:revert-hunk))
(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;; Git blame on lines
(use-package blamer)

;; Clang-format
(use-package clang-format
  :config
  (require 'cc-mode)
  (define-key c-mode-base-map (kbd "C-c f") 'clang-format-buffer))

;; Color sequences in compilation
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point-max)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Language server protocol
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  :config
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (global-set-key (kbd "M-g f") 'flymake-goto-next-error)
  (global-set-key (kbd "M-g b") 'flymake-goto-prev-error)
  :hook (
	 (c-mode . lsp)
	 )
  :commands lsp)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

;; Multiple cursor
(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

;; Theme
(use-package gruber-darker-theme
  :config
  (setq custom-safe-themes t)
  (load-theme 'gruber-darker))

;; Other keymaps
(global-set-key (kbd "C-x c") 'compile)
(put 'upcase-region 'disabled nil)
