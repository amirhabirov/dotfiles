;;; buistvo-krasok.el --- Buistvo Krasok -*- lexical-binding: t; -*-

(deftheme buistvokrasok)

(let
    ((white "#ffffea")
     (black "#333333")
     (gray  "#d3d3d3"))
  
  (custom-theme-set-faces
   'buistvokrasok
   
   ;; defaults
   `(default ((t (:background ,white :foreground ,black))))
   `(region ((t (:background ,gray :foreground ,black))))
   `(cursor ((t (:background ,black :foreground ,white))))
   `(highlight ((t (:background ,gray :foreground ,black))))
   `(lazy-highlight ((t (:background ,black :foreground ,white))))
   `(isearch ((t (:background ,black :foreground ,white))))
   `(help-key-binding ((t (:background ,white :foreground ,black :box (:color ,black)))))
   `(shadow ((t (:foreground ,black))))

   ;; mode line
   `(mode-line-inactive ((t (:background ,white :foreground ,black :box (:color ,black)))))
   `(mode-line-active ((t (:background ,gray :foreground ,black :box (:color ,black)))))

   ;; code
   `(font-lock-punctuation-face ((t (:foreground ,black))))
   `(font-lock-builtin-face ((t (:foreground ,black))))
   `(font-lock-comment-face ((t (:foreground ,black))))
   `(font-lock-constant-face ((t (:foreground ,black))))
   `(font-lock-string-face ((t (:foreground ,black))))
   `(font-lock-function-name-face ((t (:foreground ,black))))
   `(font-lock-keyword-face ((t (:foreground ,black))))
   `(font-lock-negation-char-face ((t (:foreground ,black))))
   `(font-lock-operator-face ((t (:foreground ,black))))
   `(font-lock-variable-name-face ((t (:foreground ,black))))
   `(font-lock-type-face ((t (:foreground ,black))))

   ;; parens
   `(show-paren-match ((t (:background ,gray :foreground ,black))))
   `(show-paren-mismatch ((t (:background ,white foreground ,black :box (:color ,black)))))

   ;; completion
   `(completions-annotations ((t (:foreground ,black))))
   `(orderless-match-face-0 ((t (:weight bold :underline t))))
   `(orderless-match-face-1 ((t (:weight bold :underline t))))
   `(orderless-match-face-2 ((t (:weight bold :underline t))))
   `(orderless-match-face-3 ((t (:weight bold :underline t))))

   ;; in-buffer autocompletion
   `(corfu-border ((t (:background ,black))))
   `(corfu-default ((t (:background ,white :foreground ,black))))
   `(corfu-current ((t (:background ,gray :foreground ,black))))

   ;; modal bindings
   `(meow-position-highlight-number ((t (:background ,gray :foreground ,black))))
   `(meow-search-highlight ((t (:background ,white :foreground ,black :weight bold))))
   
   ))

(provide-theme 'buistvokrasok)
