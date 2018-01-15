Brew formula for auto-multiple-choice 📖
========================================

<p align="center">
  <img src="https://user-images.githubusercontent.com/2195781/34616703-4ef9a912-f239-11e7-82ec-256acf855104.png">
</p>

Install it:

    brew install maelvalais/amc/auto-mutiple-choice

- **What are the dependencies?** Homebrew will pull automatically everything (Gtk3, Opencv) except for xquartz.
  Also, to run it, you will need to install a latex distribution (for example, Mactex can be installed by
  `brew cask install mactex`).
- **How come there has never been an official formula for Homebrew?** This is mainly because of the complexity of
  auto-multiple-choice (insane number of dependencies) as well as the fact that Homebrew does not cope well with
  latex dependencies.
- **How did you do it?** I took the macports [recipe][macports], vendored perl packages and pdftk (also dblatex but it is only used during build). Nothing is installed outside of the Homebrew environment so you don't have to worry with messing your system. The **only prerequisite** is to have Mactex (if you don't have it: `brew cask install mactex`). To install auto-mutiple-choice:

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
   
3. the PDF documentation and .tex templates (_models_) are not built by
   default; instead, I pull the current precompiled linux version from
   https://download.auto-multiple-choice.net and copy its documentation.
   You can use `--with-regenerate-doc` to build the doc/.sty instead of
   downloading them.
4. you can install the dev version using `brew install maelvalais/amc/auto-mutiple-choice --HEAD`
5. The font *Linux Libertine O* can be used in tex or amc-txt files or for
   annotating marks. Note that if you install Libertine using brew, i.e.,

       brew cask install caskroom/fonts/font-linux-libertine

   the name has no 'O' in it. The command to use in tex files is:

       \setmainfont{Linux Libertine}
    
    and in amc-tex files:

        Font: Linux Libertine


[macports]: https://github.com/macports/macports-ports/blob/d894802c28bda4045d956f327b3d5af89576bb22/x11/auto-multiple-choice/Portfile

<!--
### Notes in the Gtk3/window tabbing issue

1. The article about "Automatic NSWindow Tabbing" in macOS Sierra:
   https://developer.apple.com/library/content/releasenotes/AppKit/RN-AppKit/index.html
2. The GTK issue talking about this: https://bugzilla.gnome.org/show_bug.cgi?id=776602
3. Also, how Mozilla disabled that: https://bugzilla.mozilla.org/show_bug.cgi?id=1280546
-->

### How I managed to vendor the many perl dependencies
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
