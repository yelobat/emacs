;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

(setq user-full-name "Luke A. Holland"
      user-mail-address "lukeanthonyholland@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(use-package! ef-themes)
(load-theme 'ef-tritanopia-dark t nil)

;; Make the cursor shorter
(setq-default cursor-type '(hbar . 4))

(setq jit-lock-defer-time 0.05)

(when (boundp 'pgtk-use-im-context-on-new-connection)
  (setq pgtk-use-im-context-on-new-connection nil))
(defun +disable-pgtk-im-context-h (&optional frame)
  (when (fboundp 'pgtk-use-im-context)
    (with-selected-frame (or frame (selected-frame))
      (when (eq (framep (selected-frame)) 'pgtk)
        (pgtk-use-im-context nil)))))
(add-hook 'after-make-frame-functions #'+disable-pgtk-im-context-h)
(+disable-pgtk-im-context-h)

(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
(after! treesit
  (dolist (lang '(c cpp))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

(setq display-line-numbers-type 'relative)

(run-with-idle-timer
 2 nil
 (lambda ()
   (ignore-errors
     (save-window-excursion
       (let ((buf (eshell)))
         (when (buffer-live-p buf) (kill-buffer buf)))
       (dired-noselect "~")))))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/dotfiles/org")

(after! corfu
  (setq corfu-auto-delay 0.05
        corfu-auto-prefix 2))

(after! eglot
  (setq eglot-events-buffer-config '(:size 0 :format full))
  (setq read-process-output-max (* 4 1024 1024))

  (setq eglot-sync-connect nil
        eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5)

  (setq eglot-ignored-server-capabilities
        '(:documentHighlightProvider
          :inlayHintProvider
          :documentOnTypeFormattingProvider))

  (set-eglot-client! 'c++-ts-mode
    '("clangd" "--background-index" "-j=8" "--pch-storage=memory"
      "--header-insertion=never" "--completion-style=detailed" "--malloc-trim"))
  (set-eglot-client! 'c-ts-mode
    '("clangd" "--background-index" "-j=8" "--pch-storage=memory"
      "--header-insertion=never" "--completion-style=detailed" "--malloc-trim"))

  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:check (:workspace :json-false)
                   :checkOnSave t
                   :cargo (:targetDir t :buildScripts (:enable t))
                   :cachePriming (:enable :json-false)
                   :procMacro (:enable t)
                   :completion (:limit 50 :autoimport (:enable t))))))

;; gptel for LLMs
(use-package! gptel
  :config

  ;; Ollama cloud
  (setq
   gptel-model 'qwen3-coder-next:cloud
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "ollama.com"
                   :protocol "https"
                   :header `(("Authorization" . ,(concat "Bearer " (getenv "OLLAMA_API_KEY"))))
                   :stream t
                   :models '(qwen3-coder-next:cloud))))

;; brpel
(use-package! brpel)

;; guts
(use-package! guts)

;; ron
(use-package! ron)

;; buffer-to-pdf
(use-package! buffer-to-pdf)

;; Websocket
(use-package! websocket)

;; Motiongfx
(use-package! motiongfx)

;; Codeforces
(use-package! codeforces)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
