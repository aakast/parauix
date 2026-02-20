;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  Wayland Tools Package Definitions
;;;  Packages for Wayland utilities not in official Guix
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (packages wayland-tools)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages hardware)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages pkg-config))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; SCREEN BRIGHTNESS
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public wluma
  (package
    (name "wluma")
    (version "4.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/max-baz/wluma/releases/download/"
             version "/wluma-" version "-vendored.tar.gz"))
       (sha256
        (base32 "1s638vprilblafd5j7bg2s3k83bxiirk3gpsialzwgbp7znj8gsv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:install-source? #f
       #:vendor-dir "vendor"
       #:cargo-build-flags '("--release")
       #:phases
       (modify-phases %standard-phases
         ;; Delete the configure phase that creates guix-vendor
         (delete 'configure)
         ;; Remove Guix-created .cargo/config before build
         (add-before 'build 'use-vendored-config
           (lambda* (#:key native-inputs inputs #:allow-other-keys)
             ;; Delete any Guix-created config, keep the vendored one
             (when (file-exists? ".cargo/config")
               (delete-file ".cargo/config"))
             ;; Set LIBCLANG_PATH for bindgen
             (let ((clang (assoc-ref (or native-inputs inputs) "clang")))
               (setenv "LIBCLANG_PATH" (string-append clang "/lib")))))
         ;; Remove checksums from Cargo.lock to match patched vendor checksums
         (add-after 'patch-cargo-checksums 'patch-cargo-lock
           (lambda _
             (use-modules (ice-9 textual-ports)
                          (ice-9 regex))
             (let* ((lock-file "Cargo.lock")
                    (content (call-with-input-file lock-file get-string-all))
                    ;; Remove checksum lines from Cargo.lock
                    (patched (regexp-substitute/global
                              #f "checksum = \"[^\"]+\"\n" content 'pre 'post)))
               (call-with-output-file lock-file
                 (lambda (port)
                   (display patched port))))))
         (add-after 'install 'install-extras
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (share (string-append out "/share"))
                    (udev-rules-dir (string-append out "/lib/udev/rules.d"))
                    (systemd-user-dir (string-append share "/systemd/user")))
               (mkdir-p udev-rules-dir)
               (mkdir-p systemd-user-dir)
               (when (file-exists? "90-wluma-backlight.rules")
                 (copy-file "90-wluma-backlight.rules"
                            (string-append udev-rules-dir "/90-wluma-backlight.rules")))
               (when (file-exists? "wluma.service")
                 (copy-file "wluma.service"
                            (string-append systemd-user-dir "/wluma.service")))))))))
    (native-inputs
     (list pkg-config clang))
    (inputs
     (list eudev
           ddcutil
           v4l-utils
           vulkan-loader
           dbus))
    (home-page "https://github.com/maximbaz/wluma")
    (synopsis "Automatic screen brightness adjustment for Wayland")
    (description
     "Wluma automatically adjusts screen brightness based on screen contents
and ambient light.  It learns your preferences over time and works with
both internal laptop displays (backlight) and external monitors (DDC/CI).
Supports multiple Wayland screen capture protocols including wlr-screencopy
and ext-image-capture-source.")
    (license license:isc)))
