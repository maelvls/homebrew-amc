Brew formula for auto-multiple-choice 📖
========================================

<p align="center">
  <img src="https://user-images.githubusercontent.com/2195781/34616703-4ef9a912-f239-11e7-82ec-256acf855104.png">
</p>

Install it:

    brew install maelvalais/amc/auto-mutiple-choice

Run it:

    auto-mutiple-choice

You can also try the HEAD version from
[mercurial](https://bitbucket.org/auto-multiple-choice/auto-multiple-choice):

    brew install maelvalais/amc/auto-mutiple-choice --HEAD

## FAQ

- **What are the dependencies?** For the installation, only Xquartz is
  required. For running it, you will need to have Mactex (e.g.,
  `brew cask install mactex`).
- **How come there has never been an official formula for Homebrew?** This
  is mainly because of the complexity of auto-multiple-choice. It has an
  insane number of dependencies like Gtk+3, Opencv, Cairo, Pango,
  Imagemagick... but more importantly it has around 70 perl dependencies.
  Perl dependencies are not handled by Homebrew (Macports does handle them),
  so I have to 'vendored' them (= install them only for auto-multiple-choice,
  not system-wide). The last huge problem was the fact that Mactex is required
  for `make` but Mactex cannot be handled by Homebrew (it cannot be
  installed automatically from the formula). My workaround is to download
  the part that relies on Mactex (i.e., the doc and the .sty file).
- **When building from source, why are there so many Perl download/make/make install?**
  This is because Homebrew is not able to handle Perl dependencies, so I
  have to vendor each of the dependencies (around 70 of them), which means
  there are MANY downloads during the build phase if it is built from source.
- **When running, there is a dylib error** This is probably because it
  installed from a bottle and that the bottle was outdated. I run a daily
  cron script in order to check that the dylib links links are not broken.
  Two solutions: **1)** try reinstalling with `brew reinstall
  auto-multiple-choice`, **2)** build from source with `brew install
  auto-multiple-choice --build-from-source`. If you are still stuck, please
  run `brew linkage auto-multiple-choice` and submit an issue on Github
  in order to help me fix it.
- **How did you do it?** I took the macports [recipe][macports], vendored
  perl packages and pdftk (also dblatex but it is only used during build).
  Nothing is installed outside of the Homebrew environment so you don't
  have to worry with messing your system. The **only prerequisite** is to
  have Mactex (if you don't have it: `brew cask install mactex`). To
  install auto-mutiple-choice:

- **Why are the windows _tabbed_ like in Safari tabs?**  because it is
  using Gtk3, pop-up windows (like _Open project_) are (weirdly) opening
  as tabbed windows. This is a work-in-progress on the GTK3 side; the
  workaround is to un-tab the window by dragging out the tab, or disable
  the [feature](https://support.apple.com/kb/PH25244?locale=en_US)
  (_System preferences_ -> _Dock_ -> _Prefer tabs when opening
  documents_).
- **`automultiplechoice.sty` is not found!** This file cannot be installed
  to your Mactex distribution during installation as it requires sudo. Two
  options:
  - either you add the following to your `~.zshrc` (or `~/.bashrc` or
    whatever):

        export TEXMFHOME=/usr/local/opt/auto-multiple-choice/share/texmf-local

  - or you symlink `automultiplechoice.sty` in your TEXMFHOME:

        mkdir -p $(kpsewhich -var-value=TEXMFHOME)/tex/latex/AMC
        ln -s $(brew --prefix auto-multiple-choice)/share/texmf-local/tex/latex/AMC/automultiplechoice.sty $(kpsewhich-var-value=TEXMFHOME)/tex/latex/AMC/automultiplechoice.sty
- **The font *Linux Libertine* is not found!** Install Libertine using brew:

      brew cask install caskroom/fonts/font-linux-libertine

  Note that you must **drop the ending 'O'** in your AMC-TXT and tex files.
  The command to use in tex files is:

      \setmainfont{Linux Libertine}

  and in amc-tex files:

      Font: Linux Libertine

- **Why is x11 required by default but tex is not?** This is because I am
  trying to comply to the Homebrew core repository practices in order to
  (eventually) merge the formula to the core repo. In the core repo, `x11`
  is accepted as a default dependency (xquartz is installed on their
  testing/bottling infrastructure). In the contrary, `tex` is not accepted
  as a default dependency as Mactex is not installed during bottling.
- **Why not building doc & automultiplechoice.sty instead of downloading?**
  This is because compiling the documentation & sty is a pain, mainly
  because it needs Mactex (which is not an accepted 'default' dep for the
  Homebrew core formulas) and it also needs extra fonts (DejaVu and IPAex).
  As I noticed that the PDF documentation does not evolve a lot and that
  `automultiplechoice.sty` stays the same, I decided to copy the
  documentation from previous precompiled versions of AMC (targeted for
  linux). This is why you may notice that the doc kind of lags behind.
- **Why is the documentation outdated?** This is because I decided not to
  rebuild the whole documentation and instead download a precompiled
  tarball (for linux) and copying the 'doc' directory from there. In order
  to recompile the documentation/sty, you can still use
  `--with-regenerate-doc`.

- **The application craches after closing a warning popup** The error is:

      Gdk:ERROR:gdkeventloop-quartz.c:567:select_thread_collect_poll: assertion failed:
      (ufds[i].events == current_pollfds[i].events)

  This bug seems to be related to Gtk+3 and Quartz backend used on macOS. I
  tried to [fix the issue][gtk-craches] but it does not seem easily
  reproducible so I gave up.

[gtk-craches]: https://bitbucket.org/auto-multiple-choice/auto-multiple-choice/pull-requests/43/fix-the-assertion-failed-when-readding-an/diff#comment-53125101
[macports]: https://github.com/macports/macports-ports/blob/d894802c28bda4045d956f327b3d5af89576bb22/x11/auto-multiple-choice/Portfile

<!--
### Notes in the Gtk3/window tabbing issue

1. The article about "Automatic NSWindow Tabbing" in macOS Sierra:
   https://developer.apple.com/library/content/releasenotes/AppKit/RN-AppKit/index.html
2. The GTK issue talking about this: https://bugzilla.gnome.org/show_bug.cgi?id=776602
3. Also, how Mozilla disabled that: https://bugzilla.mozilla.org/show_bug.cgi?id=1280546
-->

## Maintainance details: vendoring the ~70 Perl dependencies

I went to http://deps.cpantesters.org and I copy-pasted the tree of dependencies
(except for 'Core modules') into a Ruby array. For example:
```ruby
      "XML::Simple",
        "XML::SAX",
          "XML::NamespaceSupport",
          "XML::SAX::Base",
```

I then gather all the ruby array with all dependencies (for example the
previous example) into a file `list_of_deps`.

Then I run

    ./list_to_resources.pl < list_of_deps > resources

and I copy everything in `resources` to the formula.

Here is `list_to_resources.pl`:
```perl
#!/usr/bin/env perl
# Lines must be of form (spaces and the comma are ignored):
#     "XML::Simple",
use MetaCPAN::Client;
my $mcpan  = MetaCPAN::Client->new();
my %already_seen = ();
foreach $line ( <STDIN> ) {
    chomp($line);
    $line =~ s/^.*"([A-Za-z:0-9]*)".*$/\1/;
    my $package = $mcpan->package($line);
    if (! exists($already_seen{$line})) {
        $already_seen{$line} = 1;
        my $url = "https://cpan.metacpan.org/authors/id/".$package->file();
        chomp(my $sha256 = `curl -sSL $url | sha256sum | cut -d' ' -f1`);
        print "resource \"$line\" do\n";
        print "  url \"".$url."\"\n";
        print "  sha256 \"".$sha256."\"\n";
        print "end\n";
    }
}
```
