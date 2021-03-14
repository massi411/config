;; Speed up
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold (* 512 1024 1024))
(add-hook 'after-init-hook
          `(lambda ()
             (setq gc-cons-threshold 800000
                   gc-cons-percentage 0.1)
             (garbage-collect)) t)
;; cl-lib -- import Common Lisp Library
(require 'cl-lib)


;;ユーザー情報
(setq user-full-name "Takushima")

;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(setq prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; バックアップファイルを作成させない
(setq make-backup-files nil)
(setq auto-save-default nil)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; 列数を表示する
(column-number-mode t)

;; 行数を表示する
(global-linum-mode t)

;; 対応する括弧を光らせる
(show-paren-mode 1)

;; 行ハイライト
(when window-system (global-hl-line-mode +1))

;; 物理行移動
(setq line-move-visual nil)

;; タブ
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)

;;;;;;; インデントして、次の行に移動する

;; (defun indent-and-next-line ()
;;   (interactive)
;;   (indent-according-to-mode)
;;   (next-line 1))

;;;;;;; 行の先頭で Ctrl-k を押すとその行ごと削除
(setq kill-whole-line t)

;; 指定行にジャンプする
(global-set-key "\C-xj" 'goto-line)

;;;; mode enable/disable
(defmacro my:enable-mode (mode)
  `(,mode 1))
(defmacro my:disable-mode (mode)
  `(,mode 0))
;;;; my:add-to-list, add function to hook
(cl-defmacro my:add-to-list (list &optional &body elements)
  `(cl-loop for e in ',elements
	    do (add-to-list ',list e)))

;;; Package Management
;; package.el
(require 'package nil t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
;;;; use-package.el
(unless (require 'use-package nil t)
  (defmacro use-package (&rest args)))
;;;; misc.
;; disable menu-bar, tool-bar, scroll-bar
(my:disable-mode menu-bar-mode)
(when window-system
  (my:disable-mode tool-bar-mode)
  (set-scroll-bar-mode 'nil))
;; theme
(load-theme 'misterioso t)
;; display line number
(setq linum-format "%5d ")
(setq display-time-interval 1)
(setq display-time-string-forms
      '((format "%s/%s/%s %s:%s:%s"
		year month day 24-hours minutes seconds)))
(my:enable-mode display-time-mode)
;;;; powerline.el
;; うまく動かない場合は外す
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))
;;  PATH -- exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))
;; key binding
(use-package bind-key
  :bind (("C-m" . newline-and-indent)
	 ("C-h" . delete-backward-char))) ; C-h -> Backspace
;; Bell
;; Alternative flash the screen
(setq visible-bell nil)
;; yes or no -> y or n
(fset 'yes-or-no-p 'y-or-n-p)
;; not add newline at end of buffer
(setq next-line-add-newlines nil)
;; kill whole line when kill line
(setq kill-whole-line t)
;; global-auto-revert-mode
(my:enable-mode global-auto-revert-mode)
;; generic-x
(use-package generic-x)
;; ファイルを開いた位置を保存する
(use-package saveplace
  :config
  (setq save-place-file (concat "~/.emacs.d/" "save-places"))
  (if (< emacs-major-version 25)
      (setq-default save-place t)
    (my:enable-mode save-place-mode))
  )
;; for same name buffer
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
	uniquify-min-dir-content 1))

;;;; auto-complete
(use-package auto-complete
  :ensure t
  :diminish auto-complete-mode abbrev-mode
  :bind (:map ac-menu-map
	      ("C-n" . ac-next)
	      ("C-p" . ac-previous)
	      :map ac-completing-map
	      ("M-/" . ac-stop)
	      ;; ("RET" . nil)
	      :map ac-complete-mode-map
	      ("C-v" . ac-my-page-next)
	      ("M-v" . ac-my-page-pre))
  :hook (((prog-mode) . (lambda () (add-to-list 'ac-sources 'ac-source-abbrev))))
  :init
  (setq ac-sources '(ac-source-filename ac-source-yasnippet ac-sources ac-source-files-in-current-dir ac-source-words-in-all-buffer ac-source-files-in-current-dir))
  :config
  (use-package auto-complete-config)
  (use-package org-ac
    :ensure t)
  (setq ac-comphist-file (concat "~/.emacs.d/" "ac-comphist.dat"))
  (my:enable-mode global-auto-complete-mode)
  (add-to-list 'ac-modes 'org-mode)
  (ac-config-default)
  (setq ac-auto-start 1)                ; n 文字以上の単語の時に補完を開始
  (setq ac-delay 0.05)                   ; n 秒後に補完開始
  (setq ac-use-fuzzy t)                 ; 曖昧マッチ有効
  (setq ac-use-comphist t)              ; 補完推測機能有効
  (setq ac-auto-show-menu 0.5)          ; n 秒後に補完メニューを表示
  (setq ac-quick-help-delay 0.5)          ; n 秒後にクイックヘルプを表示
  (setq ac-candidate-limit nil)
  (setq ac-use-menu-map t)              ; キーバインド
  (defadvice ac-word-candidates (after remove-word-contain-japanese activate)
    (let ((contain-japanese (lambda (s) (string-match (rx (category japanese)) s))))
      (setq ad-return-value
	    (remove-if contain-japanese ad-return-value))))
  (setq popup-use-optimized-column-computation nil)
  (add-to-list 'ac-modes 'enh-ruby-mode)
  (defun ac-my-page-next ()
    (interactive)
    (when (ac-menu-live-p)
      (when (popup-hidden-p ac-menu)
	(ac-show-menu))
      (dotimes (counter (1- (popup-height ac-menu)))
	(popup-next ac-menu))))
  (defun ac-my-page-pre ()
    (interactive)
    (when (ac-menu-live-p)
      (when (popup-hidden-p ac-menu)
	(ac-show-menu))
      (dotimes (counter (1- (popup-height ac-menu)))
	(popup-previous ac-menu))))
  )


;;;; python
;; emerge pyflakes pip
(use-package python-mode
  :ensure t
  ;; :ensure-system-package (pyflakes
  ;;                         pip
  ;;                         jedi
  ;;                         (epc . "pip install --user epc")
  ;;                         (autopep8 . "pip install --user autopep8")
  ;;                         (virtualenv . "pip install --user virtualenv"))
  :config
  (setq py-outline-minor-mode-p nil)
  (use-package jedi
    :ensure t
    :hook (python-mode . jedi:setup)
    :config
    (setq jedi:complete-on-dot t)
    (setq ac-sources
	  (delete 'ac-source-words-in-all-buffer ac-sources)) ; jediの補完候補だけでいい
    (my:add-to-list ac-sources ac-source-filename ac-source-jedi-direct)
    (bind-keys :map python-mode-map
	       ("C-c t" . jedi:goto-definition)
	       ("C-c b" . jedi:goto-definition-pop-marker)
	       ("C-c r" . helm-jedi-related-names))))


;;;; mwim
(use-package mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
	 ("C-e" . mwim-end-of-code-or-line)))

;;;; anzu
(use-package anzu
  :ensure t
  :diminish
  :config
  (setq anzu-search-threshold 3000)
  (my:enable-mode global-anzu-mode))

;;;; smartparens
(use-package smartparens
  :ensure t
  :diminish
  :config
  (use-package smartparens-config)
  (my:enable-mode smartparens-global-mode))
;;;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-mode magit jedi-direx auto-complete use-package smartparens rainbow-delimiters python-mode powerline popup org-ac mwim jedi exec-path-from-shell anzu)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(normal-erase-is-backspace-mode 0)

(put 'upcase-region 'disabled nil)

(setq ring-bell-function 'ignore)

;; magit
(require 'package)
(add-to-list 'package-archives
                          '("melpa" . "http://melpa.org/packages/") t)
(global-set-key (kbd "C-x g") 'magit-status)
(setq split-width-threshold 0)
(setq split-height-threshold nil)

;; emacs-neotree


(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


;;(setq lsp-keymap-prefix "s-l")
;;(require 'lsp-mode)
;;(add-hook 'python-mode-hook #'lsp)
