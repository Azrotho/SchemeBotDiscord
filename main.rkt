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

;; Register slash command
(define (register-slash-command)
  (define response
    (post (format "https://discord.com/api/v10/applications/~a/commands" APP-ID)
          #:headers (hash 'Authorization (string-append "Bot " BOT-TOKEN))
          #:json (hasheq 'name "citation"
                         'description "Répond avec une citation aléatoire !"
                         ;; 1 = USER_INSTALL
                         'integration_types '(1)
                         ;; 0 = GUILD, 1 = BOT_DM, 2 = PRIVATE_CHANNEL
                         'contexts '(0 1 2))))
  (define status (response-status-code response))
  (if (= status 200)
      (begin
        (write "Commande slash enregistrée avec succès !")
        (newline))
      (error 'register-slash-command
             "Erreur lors de l'enregistrement de la commande slash : HTTP ~a"
             status)))

(register-slash-command)
(write "Démarrage du bot Racket...")
(newline)
; (write (random-line (string-split (clean contenu) "\n")))
; (newline)
(start-client client)
(write "OK!")
(newline)