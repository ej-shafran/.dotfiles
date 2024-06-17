;; Options & Configuration

(setq display-buffer-alist
      '(("\\`\\*e?shell" magit--display-buffer-fullframe)))

(add-hook 'with-editor-mode-hook 'evil-insert-state)

(setq git-gutter:ask-p nil)
