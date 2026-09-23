#lang racket

(require racket-cord net/http-easy)

(define BOT-TOKEN (getenv "DISCORD_BOT_TOKEN"))
(define APP-ID (getenv "DISCORD_APP_ID"))

(define client (make-client BOT-TOKEN))

(write "Démarrage du bot Racket...")
(newline)
(start-client client)
(write "OK!")
(newline)