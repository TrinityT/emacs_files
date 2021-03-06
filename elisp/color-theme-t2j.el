(defun color-theme-t2j ()
  (interactive)
  (color-theme-install
   '(color-theme-t2j
     ((background-color . "#151515")
      (background-mode . dark)
      (border-color . "#ffffff")
      (cursor-color . "#1b54fe")
      (foreground-color . "white")
      (mouse-color . "black"))
     (fringe ((t (:foreground "151515" :background "111111"))))
     (mode-line ((t (:foreground "#fdfcfc" :background "#666666"))))
     (region ((t (:background "#0b08b5"))))
     (font-lock-builtin-face ((t (:foreground "#f4f556"))))
     (font-lock-comment-face ((t (:foreground "#1af943"))))
     (font-lock-function-name-face ((t (:foreground "#7898fc"))))
     (font-lock-keyword-face ((t (:foreground "#3ef5f9"))))
     (font-lock-string-face ((t (:foreground "#ef43d2"))))
     (font-lock-type-face ((t (:foreground"#d6050d"))))
     (font-lock-variable-name-face ((t (:foreground "#f0a119"))))
     (minibuffer-prompt ((t (:foreground "#7299ff" :bold t))))
     (font-lock-warning-face ((t (:foreground "Red" :bold t))))
     )))
(provide 'color-theme-t2j)
