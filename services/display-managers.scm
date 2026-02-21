;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  Display Manager Shepherd Services
;;;  Service definitions for TUI/GUI login managers
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (services display-managers)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages linux)
  #:use-module (packages display-managers)
  #:use-module (guix gexp)
  #:export (ly-shepherd-service))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; LY — SHEPHERD SERVICE
;;; ═══════════════════════════════════════════════════════════════════════════════

(define (ly-shepherd-service tty)
  "Return a Shepherd service that starts the Ly display manager on TTY.
TTY should be a string like \"7\"."
  (shepherd-service
   (documentation "Ly TUI display manager")
   (provision '(display-manager ly))
   (requirement '(user-processes host-name udev virtual-terminal dbus-system))
   (respawn? #t)
   (start #~(let* ((openvt (string-append #$util-linux "/bin/openvt"))
                    (ly-dm (string-append #$ly "/bin/ly-dm"))
                    (ly-bin (string-append #$ly "/bin/ly"))
                    (ly-cmd (if (file-exists? ly-dm) ly-dm ly-bin)))
               ((make-forkexec-constructor
                 (list openvt "-f" "-w" "-c" #$tty "--" ly-cmd)
                 #:log-file "/var/log/ly.log"))))
   (stop #~(make-kill-destructor))))
