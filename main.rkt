#lang racket

(require racket-cord net/http-easy)

(define BOT-TOKEN (getenv "DISCORD_BOT_TOKEN"))
(define APP-ID (getenv "DISCORD_APP_ID"))

(define contenu (file->string "citations.txt"))

(define client (make-client BOT-TOKEN))

(define random-line
    (lambda (lines)
        (list-ref lines (random (length lines)))))

(define (clean str)
  (define cleaned (regexp-replace* #px"[^a-zA-Z0-9\\s\\*'àâäéèêëîïôöùûüÿçÀÂÄÉÈÊËÎÏÔÖÙÛÜŸÇ]" str ""))
  (regexp-replace* #px"\\\\n" cleaned "\n"))

(define (get-random-line)
  (random-line (string-split (clean contenu) "\n")))

(write "Démarrage du bot Racket...")
(newline)
; (write (random-line (string-split (clean contenu) "\n")))
; (newline)
(start-client client)
(write "OK!")
(newline)