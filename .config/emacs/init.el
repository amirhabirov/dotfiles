;;; init.el --- Init -*- lexical-binding: t; -*-

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)

(use-package minions
  :hook (emacs-startup . minions-mode)
  :custom
  (minions-mode-line-lighter " {...}")
  (mode-line-compact t)
  (column-number-mode t))

(use-package files
  :ensure nil
  :preface
  (defun my-files-setup-version-control-dirs ()
    (let
	((autosave-dir (expand-file-name "autosaves/" user-emacs-directory))
	 (backup-dir (expand-file-name "backups/" user-emacs-directory)))
      (dolist (dir (list autosave-dir backup-dir))
	(unless (file-directory-p dir)
	  (make-directory dir)))
      (setq
       auto-save-file-name-transforms (list (list ".*" autosave-dir t))
       backup-directory-alist `(( ".*" . ,backup-dir)))))
  :custom
  (create-lockfiles nil)
  (auto-save-timeout 10)
  (auto-save-interval 200)
  (backup-by-copying t)
  (version-control t)
  (delete-old-versions t)
  (kept-new-versions 5)
  (kept-old-versions 5)
  :config
  (my-files-setup-version-control-dirs))

(use-package files
  :ensure nil
  :preface
  (defconst sioyek-regexps '("\\.pdf\\'" "\\.epub\\'" "\\.mobi\\'"))
  (defconst zathura-regexps '("\\.djvu\\'" "\\.fb2\\'"))
  (defconst feh-regexps '("\\.png\\'" "\\.jpg\\'" "\\.jpeg\\'"))
  (defconst mpv-video-regexps '("\\.mkv\\'" "\\.mov\\'" "\\.mp4\\'" "\\.webm\\'"))
  (defconst mpv-visual-regexps '("\\.gif\\'"))
  (defconst mpv-audio-regexps '("\\.mp3\\'"))
  (defun my-open-with (program filename) 
    (let*
	((abs-fn (expand-file-name filename))
	 (cmd (format "%s '%s' > /dev/null 2>&1 &" program abs-fn)))
      (call-process-shell-command cmd)))
  (defun my-string-match (regexps string)
    (cl-find-if (lambda (regexp) (string-match regexp string)) regexps))
  (defun my-files-maybe-open-externally (orig-fun &rest args)
    (let ((filename (car args)))
      (cond
       ((my-string-match sioyek-regexps filename)
	(my-open-with "sioyek --new-window" filename))
       ((my-string-match zathura-regexps filename)
	(my-open-with "zathura" filename))
       ((my-string-match feh-regexps filename)
	(my-open-with "feh" filename))
       ((my-string-match mpv-video-regexps filename)
	(my-open-with "mpv" filename))
       ((my-string-match mpv-visual-regexps filename)
	(my-open-with "mpv" filename))
       ((my-string-match mpv-audio-regexps filename)
	(my-open-with "mpv" filename))
       (t
	(apply orig-fun args)))))
  :config
  (advice-add 'find-file :around #'my-files-maybe-open-externally))

(use-package centered-cursor-mode
  :hook (emacs-startup . global-centered-cursor-mode))

(use-package golden-ratio
  :hook (emacs-startup . golden-ratio-mode)
  :custom
  (golden-ratio-auto-scale t)
  (golden-ratio-exclude-modes '(dired-mode vundo-mode)))

(use-package orderless
  :custom
  (orderless-style-dispatchers '(orderless-affix-dispatch))
  (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package vertico
  :hook (emacs-startup . vertico-mode))

(use-package marginalia
  :hook (emacs-startup . marginalia-mode))

(use-package consult
  :bind
  (([remap switch-to-buffer] . consult-buffer)
   ([remap list-buffers] . consult-buffer)
   ([remap isearch-forward] . consult-line)
   ([remap isearch-backward] . consult-line)
   ([remap goto-line] . consult-goto-line)
   ([remap bookmark-set] . consult-bookmark)
   ([remap bookmark-jump] . consult-bookmark)))

(use-package undo-fu-session
  :hook (emacs-startup . undo-fu-session-global-mode)
  :custom  
  (undo-limit (* 13 160000))
  (undo-strong-limit (* 13 240000))
  (undo-outer-limit (* 13 24000000)))

(use-package vundo
  :bind
  (([remap undo] . vundo)
   ([remap undo-redo] . vundo)))

(use-package emacs
  :ensure nil
  :custom (use-short-answers t))

(use-package simple
  :ensure nil
  :custom
  (blink-match-paren nil)
  (cursor-face-highlight-nonselected-window nil))

(use-package emacs
  :ensure nil
  :custom (highlight-nonselected-windows nil))

(use-package corfu
  :hook
  (((prog-mode text-mode) . global-corfu-mode)
   ((prog-mode text-mdoe) . corfu-popupinfo-mode))
  :custom
  (corfu-cycle t)
  (corfu-quit-no-match nil)
  (corfu-quit-at-boundary nil)
  (corfu-popupinfo-delay nil)
  (corfu-bar-width 0)
  (corfu-left-margin-width 0)
  (corfu-right-margin-width 0))

(use-package cape
  :preface
  (defun my-cape-capf-prog-mode ()
    "Define `completion-at-point-functions` for `prog-mode`."
    (unless (eq major-mode 'emacs-lisp-mode)
      (setq-local completion-at-point-functions
		  (cape-capf-buster
		   (cape-capf-sort
		    (cape-capf-super #'cape-dabbrev
				     #'cape-keyword))))))
  (defun my-cape-capf-text-mode ()
    "Define `completion-at-point-functions` for `text-mode`."
    (setq-local completion-at-point-functions
		(cape-capf-buster
		 (cape-capf-sort
		  (cape-capf-super #'cape-dabbrev
				   #'cape-dict)))))
  :hook
  ((prog-mode . my-cape-capf-prog-mode)
   (text-mode . my-cape-capf-text-mode)))

(use-package paren
  :ensure nil
  :custom
  (show-paren-delay 0)
  (show-paren-when-point-in-periphery t)
  (show-paren-when-point-inside-paren t))

(use-package compile
  :ensure nil
  :preface
  (defun my-compilation-next-error ()
    (compilation-next-error 1)
    (let ((inhibit-message t))
      (compilation-display-error)))
  (defun my-compilation-previous-error ()
    (compilation-previous-error 1)
    (let ((inhibit-message t))
      (compilation-display-error)))
  :bind
  (([remap compilation-next-error] . my-compilation-next-error)
   ([remap compilation-previous-error] . my-compilation-previous-error))
  :hook
  (compilation-mode . turn-on-font-lock)
  :custom
  (compilation-ask-about-save nil)
  (compilation-always-kill t)
  (compilation-scroll-output 'first-error))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (before-save . gofmt-before-save))
	
(use-package format-all
  :preface
  (defun my-format-all-mode ()
    (format-all-ensure-formatter)
    (format-all-mode))
  :hook
  ((c-mode python-mode sql-mode) . format-all-mode)
  :custom
  (format-all--default-formatters
   '(("C" astyle)
     ("Python" ruff)
     ("SQL" pgformatter))))

(use-package devdocs)

(use-package emacs
  :ensure nil
  :preface
  (defun my-translate-text (text)
    "Translate specified slice of text with goldendict-ng."
    (interactive "sText: ")
    (let ((translator "goldendict"))
      (start-process translator nil translator text)))
  (defun my-translate-text-at-point ()
    "Translate selected region of text or symbol at point with goldendict-ng."
    (interactive)
    (let ((text ""))
      (if (use-region-p)
	  (setq text (buffer-substring-no-properties
		      (use-region-beginning) (use-region-end)))
	(setq text (thing-at-point 'symbol t)))
      (when (or (not text) (string-empty-p text))
	(user-error "No text at point were provided."))
      (my-translate-text text)))
  :bind
  (("C-c g" . my-translate-text)
   ("C-c C-g" . my-translate-text-at-point)))
 

(use-package pass)

(use-package magit)

(use-package forge)

(use-package fj)

(use-package org-roam)

(use-package org-super-agenda)

(use-package telega
  :defer 5
  :preface
  (defun my-telega-proxify-connection ()
    "Proxify telega.el connection with MTProto proxy."
    (let*
	((name "tg-ws-proxy")
	 (bin (executable-find name)))
      (unless bin
	(error "telega.el: tg-ws-proxy executable is not found."))
      (let*
	  ((cmd (concat "pgrep -cx " name))
	   (res (string-to-number (shell-command-to-string cmd))))
	(when (zerop res)
	  (start-process name nil bin)))
      (let*
	  ((fn "TgWsProxy/config.json")
	   (cfg (expand-file-name fn (xdg-config-home))))
	(unless (file-exists-p cfg)
	  (error "telega.el: tg-ws-proxy configuration file doesn't exist."))
	(with-temp-buffer
	  (insert-file-contents cfg)
	  (let*
	      ((json-object-type 'plist)
	       (data (json-read))
	       (host (plist-get data :host))
	       (port (plist-get data :port))
	       (secret (plist-get data :secret)))
	    (unless (and host port secret)
	      (error "telega.el: tg-ws-proxy host, port, or secret is mailformed."))
	    (telega--addProxy
                `(:server ,host
                          :port ,port
                          :type (:@type "proxyTypeMtproto" :secret ,secret))
		'enable))))))
  (defun my-telega-disable-ipv6 ()
    "Prevent telega.el from connecting to telegram servers through IPv6."
    (plist-put telega-options-plist :prefer_ipv6 :false))
  (defun my-telega-mode-line-string-format ()
    "Custom telega.el mode line indicator format."
    (let ((ucc (plist-get telega--unread-chat-count :unread_unmuted_count)))
      (when (> ucc 0)
	(format "(#;%d)" ucc))))
  :hook
  ((telega-before-auth . my-telega-proxify-connection)
   (telega-load . my-telega-disable-ipv6))
  :custom
  (telega-mode-line-string-format '(:eval (my-telega-mode-line-string-format)))
  (telega-use-images t)
  (telega-filters-custom nil)
  :config
  (telega-proxy-status-mode)
  (telega-mode-line-mode)
  (telega t))

(use-package notmuch)

(use-package consult-notmuch)

(use-package consult-flyspell)
(use-package flyspell-correct)

(use-package notmuch-indicator
  :custom
  (notmuch-indicator-counter-format "(%s;%s)")
  (notmuch-indicator-hide-empty-counters t)
  (notmuch-indicator-refresh-count nil))

(use-package org
  :ensure nil
  :custom
  (org-directory "~/Documents/org"))

(use-package org-agenda
  :ensure nil
  :bind ("C-c a" . org-agenda-list)
  :custom
  (org-agenda-files (list org-directory))
  (org-agenda-window-setup 'reorganize-frame)
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-compact-blocks t)
  (org-agenda-sticky t)
  (org-agenda-start-on-weekday nil)
  (org-agenda-show-future-repeats nil)
  (org-agenda-tags-column 50))

(use-package meow
  :demand t
  :preface
  (defun my-meow-qwerty-layout-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("v" . meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("<escape>" . ignore)))
  :config
  (defalias #'view-hello-file #'ignore)
  (setq
   meow-use-clipboard t
   meow-use-cursor-position-hack t
   meow-expand-hint-remove-delay t
   meow-expand-hint-counts
   '((word . 10)
     (line . 10)
     (block . 10)
     (find . 10)
     (till . 10)
     (symbol . 10)))
  (my-meow-qwerty-layout-setup)
  (meow-global-mode))
