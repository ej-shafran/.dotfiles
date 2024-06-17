;; Constant for the configuration directory
(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

;; Function that loads a configuration file
(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

;; UI settings
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Use other file for `customize` settings
(setq custom-file (expand-file-name "custom.el" user-init-dir))
;; Load themes directory
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-init-dir))
;; Use Tokyo Night theme
(load-theme 'tokyo t)

;; Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Modify used certificates
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
;; Add `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Load `use-package`
(eval-when-compile
  (require 'use-package))

;; Evil Mode (Vim keybindings)
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-leader nil (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>gg") 'magit)
  (evil-define-key 'normal 'global (kbd "<leader>ff") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader>qq") 'save-buffers-kill-emacs))
;; Evil Mode for other parts of Emacs
(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init))

;; Magit (Git client)
(use-package magit
  :ensure t
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

;; Company (autocomplete)
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (evil-define-key 'insert 'global (kbd "C-n") 'company-complete)
  (evil-define-key 'insert 'company-mode (kbd "C-y") 'company-complete-selection)
  ;; Disable some default keybindings
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-active-map (kbd "<tab>") nil))

;; Ivy (better command completion)
(use-package ivy
  :ensure t
  :config
  (ivy-mode))

;; Which-Key (help with keymaps)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))
