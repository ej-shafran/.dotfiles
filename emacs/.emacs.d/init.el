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

;; Theme
(use-package gruber-darker-theme
  :config
  (setq custom-safe-themes t)
  (load-theme 'gruber-darker))

;; Other keymaps
(global-set-key (kbd "C-x c") 'compile)
