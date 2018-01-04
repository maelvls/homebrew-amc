I took the macports [recipe][macports], vendored perl packages and pdftk (also dblatex but it is only used during build). Nothing is installed outside of the Homebrew environment so you don't have to worry with messing your system. To try it:

    brew install maelvalais/amc/auto-mutiple-choice

Having Mactex is mandatory during the build (it is needed in order to build `automutiplechoice.sty`). One way to install it is:

    brew cask install mactex

Notes:
1. because it is using Gtk3, pop-up windows (like _Open project_) are (weirdly) opening as tabbed
   windows. This is a work-in-progress on the GTK3 side; the workaround is to un-tab the window by
   dragging out the tab, or disable the [feature](https://support.apple.com/kb/PH25244?locale=en_US)
   (_System preferences_ -> _Dock_ -> _Prefer tabs when opening documents_).
2. the `automultiplechoice.sty` file is not automatically installed in you Mactex installation. Two options:
   - either you add the following to your `~.zshrc`:

         export TEXMFHOME=/usr/local/opt/auto-multiple-choice/share/texmf-local

   - or you symlink `automultiplechoice.sty` in your TEXMFHOME:

         mkdir -p $(kpsewhich -var-value=TEXMFHOME)/tex/latex/AMC
         ln -s $(brew --prefix auto-multiple-choice)/share/texmf-local/tex/latex/AMC/automultiplechoice.sty $(kpsewhich -var-value=TEXMFHOME)/tex/latex/AMC/automultiplechoice.sty

- the PDF documentation and .tex templates (_models_) are not built by default. Use `--with-doc` to them (I disabled it as it didn't work because of a problem with the japanese fonts)
- ~~you can install the dev version using `--HEAD`~~ installing with `--HEAD` is not working for now because of a [`brew` bug](https://github.com/Homebrew/brew/issues/3628)

[macports]: https://github.com/macports/macports-ports/blob/d894802c28bda4045d956f327b3d5af89576bb22/x11/auto-multiple-choice/Portfile