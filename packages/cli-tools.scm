;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  CLI Tools Package Definitions
;;;  Packages for CLI tools not in official Guix
;;;
;;;  These are mostly Go/Rust binaries from GitHub releases.
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (packages cli-tools)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages image)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages video)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xorg))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; CHARMBRACELET TOOLS
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public glow
  (package
    (name "glow")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/charmbracelet/glow/releases/download/v"
             version "/glow_" version "_Linux_x86_64.tar.gz"))
       (sha256
        (base32 "1rca0pr2x68alg7qjb2bxwx8iyw216q33s9rlbci2lj52vy6fq61"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("glow" "bin/"))))
    (home-page "https://github.com/charmbracelet/glow")
    (synopsis "Render markdown on the CLI with pizzazz")
    (description
     "Glow is a terminal based markdown reader designed from the ground up
to bring out the beauty—and power—of the CLI.")
    (license license:expat)))

(define-public mods
  (package
    (name "mods")
    (version "1.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/charmbracelet/mods/releases/download/v"
             version "/mods_" version "_Linux_x86_64.tar.gz"))
       (sha256
        (base32 "04135idbcmjv8c3b5g8zgmp500k5hm68bcafnmg3lw5mp3bfad5h"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("mods" "bin/"))))
    (home-page "https://github.com/charmbracelet/mods")
    (synopsis "AI on the command line")
    (description
     "Mods is a command-line interface for interacting with AI language models.
It supports multiple providers and can be used in pipelines.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; SHELL & HISTORY
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public atuin
  (package
    (name "atuin")
    (version "18.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/atuinsh/atuin/releases/download/v"
             version "/atuin-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32 "14hp673i8in9adahg01bldlwyip7kg5vdnqi5jczinv8ibxnswg3"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("atuin" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/atuin"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-append gcc-lib "/lib:" libc "/lib")))
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain))
    (home-page "https://atuin.sh")
    (synopsis "Magical shell history")
    (description
     "Atuin replaces your existing shell history with a SQLite database,
and records additional context for your commands. It provides optional
and fully encrypted synchronization between machines.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; GIT TOOLS
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public lazygit
  (package
    (name "lazygit")
    (version "0.44.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/jesseduffield/lazygit/releases/download/v"
             version "/lazygit_" version "_Linux_x86_64.tar.gz"))
       (sha256
        (base32 "1g0d8p1acyqrhy6ws7frkpp1lrg81wh350xwzyix0jd4sm52ys44"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("lazygit" "bin/"))))
    (home-page "https://github.com/jesseduffield/lazygit")
    (synopsis "Simple terminal UI for git commands")
    (description
      "Lazygit is a simple terminal UI for git commands, written in Go.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; TERMINALS
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public kitty-bin
  (package
    (name "kitty-bin")
    (version "0.45.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/kovidgoyal/kitty/releases/download/v"
             version "/kitty-" version "-x86_64.txz"))
       (sha256
        (base32 "1nl04cv8vx1zszdbpciqikqhrq42pnzrxivmcxwq2ld3m5khidz6"))))
    (build-system copy-build-system)
    (arguments
       '(#:install-plan
        '(("bin/" "bin/")
          ("lib/" "lib/")
          ("share/applications/" "share/applications/")
          ("share/icons/" "share/icons/"))
       #:phases
       (modify-phases %standard-phases
         (replace 'unpack
           (lambda* (#:key source #:allow-other-keys)
             (invoke "tar" "-xJf" source)))
         (delete 'validate-runpath))))
    (supported-systems '("x86_64-linux"))
    (home-page "https://sw.kovidgoyal.net/kitty/")
    (synopsis "Fast, featureful, GPU based terminal emulator")
    (description
     "Kitty is a fast, featureful, GPU-based terminal emulator with support for
Wayland/X11, modern terminal protocol extensions, and scriptable remote control.
This package uses the official upstream Linux binary bundle.")
    (license license:gpl3+)))


;;; ═══════════════════════════════════════════════════════════════════════════════
;;; SYSTEM UTILITIES
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public battop
  (package
    (name "battop")
    (version "0.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/svartalf/rust-battop/releases/download/v"
             version "/battop-v" version "-x86_64-unknown-linux-gnu"))
       (sha256
        (base32 "1r8ds5f8j6cm7ffxk1c8ha1rga0pzw674mswhbiyz8jhsl1ijq4b"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("battop-v0.2.4-x86_64-unknown-linux-gnu" "bin/battop"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/battop"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-append gcc-lib "/lib:" libc "/lib")))
               (chmod bin #o755)
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain))
    (home-page "https://github.com/svartalf/rust-battop")
    (synopsis "Interactive battery viewer")
    (description
     "Battop is an interactive TUI viewer for batteries, similar to htop.
It shows battery percentage, charge rate, time remaining, and health information.")
    (license license:asl2.0)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; MANGA & MEDIA
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public manga-tui
  (package
    (name "manga-tui")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/josueBarretogit/manga-tui/releases/download/v"
             version "/manga-tui-" version "-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32 "0wsifym4hp2l78z1haykn3n2lzx8lpbbi4i11m64zdapl03dpksv"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("manga-tui" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/manga-tui"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (dbus (assoc-ref inputs "dbus"))
                    (openssl (assoc-ref inputs "openssl"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-join
                            (list (string-append gcc-lib "/lib")
                                  (string-append libc "/lib")
                                  (string-append dbus "/lib")
                                  (string-append openssl "/lib"))
                            ":")))
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain dbus openssl))
    (home-page "https://github.com/josueBarretogit/manga-tui")
    (synopsis "Terminal-based manga reader and downloader")
    (description
     "Manga-tui is a terminal-based manga reader and downloader with image
rendering support.  It supports multiple manga providers including Mangadex,
Weebcentral, and MangaPill, with features like advanced search, reading
history, Anilist integration, and downloads in CBZ, EPUB, PDF formats.")
    (license license:expat)))

(define-public duf
  (package
    (name "duf")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/muesli/duf/releases/download/v"
             version "/duf_" version "_linux_x86_64.tar.gz"))
       (sha256
        (base32 "1mq8hja9d0ga87i8xdfa498ivyafkfwm65dsq37lmw0dfgnkwd58"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("duf" "bin/"))))
    (home-page "https://github.com/muesli/duf")
    (synopsis "Disk Usage/Free Utility - a better 'df' alternative")
    (description
     "Duf is a modern replacement for df with colorful output and sorting options.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; SECRETS MANAGEMENT
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public sops
  (package
    (name "sops")
    (version "3.9.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/getsops/sops/releases/download/v"
             version "/sops-v" version ".linux.amd64"))
       (sha256
        (base32 "1vcylc3alv32zb5nga59rgybfhz8cb2qbv2bp895pw737ysrp4wd"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("sops-v3.9.2.linux.amd64" "bin/sops"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (chmod (string-append (assoc-ref outputs "out") "/bin/sops") #o755))))))
    (home-page "https://github.com/getsops/sops")
    (synopsis "Simple and flexible tool for managing secrets")
    (description
     "SOPS is an editor of encrypted files that supports YAML, JSON, ENV, INI
and BINARY formats and encrypts with AWS KMS, GCP KMS, Azure Key Vault, age, and PGP.")
    (license license:mpl2.0)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; EMAIL
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public himalaya
  (package
    (name "himalaya")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/pimalaya/himalaya/releases/download/v"
             version "/himalaya-x86_64-linux.tar.gz"))
       (sha256
        (base32 "1da9pfwbz6r6rkigh5ljn0phq7iw4p9awr5258ww2qrdng2dy680"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("himalaya" "bin/"))))
    (home-page "https://pimalaya.org/himalaya/")
    (synopsis "CLI to manage emails")
    (description
     "Himalaya is a CLI to manage emails based on the email-lib Rust library.
It supports IMAP, Maildir, notmuch, SMTP, and sendmail.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; TASK MANAGEMENT
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public todo.txt-cli
  (package
    (name "todo.txt-cli")
    (version "2.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/todotxt/todo.txt-cli/releases/download/v"
             version "/todo.txt_cli-" version ".tar.gz"))
       (sha256
        (base32 "0pyii7z9mgf9z8z7linxfh69ckrsayv3y41w449c5ai9811jbffk"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out"))
                          "INSTALL=install")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check))
       #:tests? #f))
    (inputs (list bash))
    (home-page "http://todotxt.org/")
    (synopsis "Simple and extensible shell script for managing todo.txt")
    (description
     "Todo.txt CLI is a simple, extensible shell script for managing your
todo.txt file.")
    (license license:gpl3+)))

(define-public taskopen
  (package
    (name "taskopen")
    (version "2.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jschlatow/taskopen")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "108mik5ygj5d3m17mviwmaysx5rrn3z5bbffdpwsz2wy4wwzh5py"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check))
       #:tests? #f))
    (inputs (list perl bash))
    (home-page "https://github.com/jschlatow/taskopen")
    (synopsis "Open links and files in Taskwarrior annotations")
    (description
     "Taskopen allows you to open links and files annotated in Taskwarrior tasks.")
    (license license:gpl2+)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; SOCIAL & MESSAGING
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public nostui
  (package
    (name "nostui")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/akiomik/nostui/releases/download/v"
             version "/nostui-v" version "-linux-x86_64.tar.gz"))
       (sha256
        (base32 "0fav6q0a312ihqdfmfq0ck7cyvs17j4paylzijmxp1xv0vi16mp7"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("nostui" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/nostui"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-append gcc-lib "/lib:" libc "/lib")))
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain))
    (home-page "https://github.com/akiomik/nostui")
    (synopsis "TUI client for Nostr")
    (description
     "Nostui is a terminal user interface client for the Nostr decentralized
social network protocol.  It allows browsing and interacting with Nostr
relays directly from the terminal.")
    (license license:expat)))

(define-public iamb
  (package
    (name "iamb")
    (version "0.0.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/ulyssa/iamb/releases/download/v"
             version "/iamb-x86_64-unknown-linux-musl.tgz"))
       (sha256
        (base32 "03f6gnnbk9yi929dil03mvhy0jdn1a017xdhw7rw0573qfmxhkjr"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("iamb" "bin/")
         ("docs/iamb.1" "share/man/man1/")
         ("docs/iamb.5" "share/man/man5/")
         ("docs/iamb.desktop" "share/applications/"))))
    (home-page "https://iamb.chat")
    (synopsis "Matrix client for Vim addicts")
    (description
     "Iamb is a Matrix client for the terminal that uses Vim keybindings.
It supports multiple profiles, end-to-end encryption via the matrix-sdk-crypto
crate, message editing, reactions, threads, read markers, image previews,
and more.  Statically linked (musl).")
    (license license:asl2.0)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; NOTES & KNOWLEDGE
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public basalt
  (package
    (name "basalt")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/erikjuhani/basalt/releases/download/basalt/v"
             version "/basalt-" version "-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32 "144ava8065vwxand2810yrl38p9g2x9vrppc4msv2jb9fqvklg2s"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       '(("x86_64-unknown-linux-gnu/release/basalt" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/basalt"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-append gcc-lib "/lib:" libc "/lib")))
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain))
    (home-page "https://github.com/erikjuhani/basalt")
    (synopsis "TUI for managing Obsidian notes")
    (description
     "Basalt is a terminal user interface for managing Obsidian vaults
and notes.  It provides a fast, keyboard-driven way to browse, search,
and organize Obsidian markdown notes without launching the full Obsidian
application.")
    (license license:expat)))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; MEDIA - YouTube & Video
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-public youtube-tui
  (package
    (name "youtube-tui")
    (version "0.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/Siriusmart/youtube-tui/releases/download/v"
             version "/youtube-tui-full_arch-x86_64"))
       (sha256
        (base32 "1f05z1kc2i4jvbbm4lcsyxx1i6dawxsa3bhcp8kb3864ryyqsv9y"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       '(("youtube-tui-full_arch-x86_64" "bin/youtube-tui"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'patch-binary
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/youtube-tui"))
                    (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                    (libc (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc-toolchain"))
                    (openssl (assoc-ref inputs "openssl"))
                    (libsixel (assoc-ref inputs "libsixel"))
                    (mpv (assoc-ref inputs "mpv"))
                    (libxcb (assoc-ref inputs "libxcb"))
                    (ld-so (string-append libc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-join
                            (list (string-append gcc-lib "/lib")
                                  (string-append libc "/lib")
                                  (string-append openssl "/lib")
                                  (string-append libsixel "/lib")
                                  (string-append mpv "/lib")
                                  (string-append libxcb "/lib"))
                            ":")))
               (chmod bin #o755)
               (invoke patchelf "--set-interpreter" ld-so bin)
               (invoke patchelf "--set-rpath" rpath bin)))))))
    (native-inputs (list patchelf))
    (inputs (list glibc gcc-toolchain openssl libsixel mpv libxcb))
    (home-page "https://github.com/Siriusmart/youtube-tui")
    (synopsis "TUI for browsing and watching YouTube")
    (description
     "YouTube-tui is a terminal user interface for YouTube that allows
browsing, searching, and watching videos directly from the terminal.
This is the @code{full} variant with both RustyPipe and Invidious
backends.  Requires mpv for video playback.")
    (license license:gpl3+)))

(define-public yt-x
  (package
    (name "yt-x")
    (version "0.4.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/Benexl/yt-x/archive/refs/tags/v"
             version ".tar.gz"))
       (sha256
        (base32 "1xbkqfq4w2i6aq7sfa8hydq06rindadnzpw0ka57k2c4d8l83lb0"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       '(("yt-x" "bin/")
         ("extensions/" "share/yt-x/extensions/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'wrap-script
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (guix build utils))
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/yt-x"))
                    (path (string-join
                           (map (lambda (pkg)
                                  (string-append (assoc-ref inputs pkg) "/bin"))
                                '("bash" "coreutils" "jq" "fzf"
                                  "yt-dlp" "mpv" "ffmpeg" "curl"))
                           ":")))
               (wrap-program bin
                 `("PATH" ":" prefix (,path)))))))))
    (inputs (list bash coreutils jq fzf yt-dlp mpv ffmpeg curl))
    (home-page "https://github.com/Benexl/yt-x")
    (synopsis "Bash script for browsing and playing YouTube videos")
    (description
     "yt-x is a feature-rich bash script for browsing and playing YouTube
videos from the terminal.  It uses yt-dlp for video extraction, fzf for
interactive selection, and mpv for playback.  Supports search, playlists,
channels, downloads, preview images, and a configurable extension system.")
    (license license:expat)))
