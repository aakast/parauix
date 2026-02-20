;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  Nonfree Package References
;;;  These packages require the nonguix channel
;;;
;;;  This file documents what's available from nonguix - it doesn't define packages,
;;;  just re-exports them for convenience.
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (packages nonfree)
  #:use-module (guix packages))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; NONFREE PACKAGES AVAILABLE FROM NONGUIX CHANNEL
;;; ═══════════════════════════════════════════════════════════════════════════════
;;;
;;; To use these, enable the nonguix channel in channels.scm, then:
;;;   guix install signal-desktop element-desktop firefox
;;;
;;; Communication:
;;;   - signal-desktop     ; Signal messenger
;;;   - element-desktop    ; Matrix client
;;;   - discord            ; Discord client
;;;   - slack              ; Slack client
;;;   - zoom               ; Zoom client
;;;
;;; Browsers:
;;;   - firefox            ; Mozilla Firefox (trademark issues)
;;;   - chromium           ; Google Chromium
;;;   - google-chrome      ; Google Chrome
;;;
;;; Development:
;;;   - vscode             ; Visual Studio Code
;;;
;;; Gaming:
;;;   - steam              ; Steam client
;;;
;;; VPN:
;;;   - mullvad-vpn        ; Mullvad VPN client
;;;
;;; Notes:
;;;   - obsidian           ; Note-taking app
;;;
;;; ═══════════════════════════════════════════════════════════════════════════════
