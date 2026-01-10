(require "helix/editor.scm")

(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "mattwparas-helix-package/splash.scm")

(provide git-add
         open-helix-scm
         open-init-scm
         expanded-shell)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;;@doc
;; Specialized shell - also be able to override the existing definition, if possible.
(define (expanded-shell . args)
  ;; Replace the % with the current file
  (define expanded
    (map (lambda (x)
           (if (equal? x "%")
               (current-path)
               x))
         args))
  (apply helix.run-shell-command expanded))

;;@doc
;; Open the helix.scm file
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

;;@doc
;; Opens the init.scm file
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))


(define (git-add)
  (expanded-shell "git" "add" "%"))

(when (equal? (command-line) '("hx"))
  (show-splash))
