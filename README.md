🍺 Brew formula for auto-multiple-choice 📖
==========================================

<p align="center">
  <img width="420" alt="capture d ecran 2018-10-06 a 11 31 01" src="https://user-images.githubusercontent.com/2195781/46569894-26cddd00-c95c-11e8-9efd-6aa7fa3a6eb8.png">
  <img width="390" alt="capture d ecran 2018-10-06 a 11 23 47" src="https://user-images.githubusercontent.com/2195781/46569889-0867e180-c95c-11e8-98ad-969735cbb76f.png">
</p>

|                      Install                      |  Run (in your shell)   |
|:-------------------------------------------------:|:----------------------:|
| `brew install maelvalais/amc/auto-multiple-choice`| `auto-multiple-choice` |


Brew will try to install using a precompiled version of AMC (bottle) that
is built on Travis-ci. Every night, an automated installation of the bottle
is done as well as `brew linkage auto-mutiple-choice` in order to check
that the bottle is still working.

[![Build Status](https://travis-ci.org/maelvalais/homebrew-amc.svg?branch=master)](https://travis-ci.org/maelvalais/homebrew-amc)
[![Stable bottle version](https://img.shields.io/bintray/v/maelvalais/bottles-amc/auto-multiple-choice.svg?label=bottle) ](https://bintray.com/maelvalais/bottles-amc/auto-multiple-choice/_latestVersion)
[ ![Devel bottle version](https://img.shields.io/bintray/v/maelvalais/bottles-amc/auto-multiple-choice-devel.svg?label=bottle) ](https://bintray.com/maelvalais/bottles-amc/auto-multiple-choice-devel/_latestVersion)

# News

## Oct. 4th, 2018: 1.4.0-rc2 and auto-multiple-choice-devel formula

I was kind of frustrated at the fact that using `--devel` was taking a LOT of
time, and updating it was thus a pain. I decided to create a real formula
called `auto-multiple-choice-devel` that replaces the use of `--devel`. What's
nice is that you will get precompiled: way less waiting when installing!!!

To sum up:

1. **`--devel` won't work anymore**,
2. instead, use **`brew install auto-multiple-choice-devel`**.
3. `auto-multiple-choice` and `auto-multiple-choice-devel` cannot be linked at
   simultanously (obviously).

## July 5th, 2018: 1.4.0-rc1

I updated the `--devel` version with the latest release candidate.

## May 17th, 2018: try the coming 1.4.0-beta version!

You can enable the development version using:

    brew install maelvalais/amc/auto-multiple-choice --devel

It will install the latest beta available. Note that due to Homebrew limitations,
bottles cannot be built for devel versions, resulting in a longer installation
time (it will need to download and install all the Perl dependencies).

## March 19th, 2018: Scan detection works again!

We fixed the above bug (see [PR53]). Everything should be back to normal in 1.3.0.2199.
~~Note that bottles won't be available for a couple of days, but it only means that
the installation will be slightly longer in the meantime!~~ done!

[PR53]: https://bitbucket.org/auto-multiple-choice/auto-multiple-choice/pull-requests/53/amc-detect-fix-errors-with-opencv-341-by

## March 15th, 2018: Fixed: ~~OpenCV breaks scan detection~~

Homebrew updated OpenCV from 3.4.0 to 3.4.1. In 3.4.0, the C headers of OpenCV used
in AMC were fine (athough they have been [deprecated](https://github.com/opencv/opencv/issues/6221)
for a long time now) but in 3.4.1 the function `cvLoadImage()` breaks.  I'll see if we can move
away from the C bindings in `AMC-detect.cc` (which is the culprit, see
[the issue](https://github.com/maelvalais/homebrew-amc/issues/4)) but that will take some
days and even more time for pushing that upstream.

## March 14th, 2018: build from source until March 17th

Homebrew has a bug that prevents me from creating bottles for a few days. I'll
re-enable the bottles as soon as brew [releases version 1.5.11](https://github.com/Homebrew/brew/releases).
Until then, we must build from source, meaning that many perl packages will be
downloaded and built during installation. Sorry for that!

## Febrary 3rd, 2018: brew update thows 'rebase' errors

⚠️  If you get the following error when Homebrew updates: ⚠️
```
Recorded preimage for 'auto-multiple-choice.rb'
error: Failed to merge in the changes.
Patch failed at 0001 amc: use the fork bitbucket.org/maelvalais/auto-multiple-choice
The copy of the patch that failed is found in: .git/rebase-apply/patch
```
Sorry for that, I am **really** dumb on this one. I force-pushed homebrew-amc
in order to revert the 2166 version. This is because I had created a fork
with a different version numbering; later, the commits in my fork were merged into
the main AMC repo and the version was 2161. `brew audit` would tell me not to
have a version number lower than the previous ones... **Solution:**

    git -C $(brew --repo maelvalais/amc) reset --hard origin/master


# FAQ
- **Why is the _reduce_ button not working?** This issue is discussed
  [here][issue-reduce-button]. In short, it is related to the Glade UI toolkit
  which doesn't seem to be great with the Quartz (macOS) backend of Gtk3. The
  same issue appears when using Glade itself. Can't fix it from the AMC project
  itself 😔  
- **How can I uninstall in a clean way?** If you want to go back to Macport's
  auto-multiple-choice or you want to simply get rid or brew's installation,
  you can uninstall using `brew uninstall auto-multiple-choice` (see [uninstall-brew]
  for uninstalling homebrew totally). If anything went wrong (bugs, errors), I would
  be pleased to see an issue opened on Github (or contact me by email at
  mael.valais@gmail.com, but I would prefer that an issue is opened 😊).
- **What are the dependencies?** For the installation, only Xquartz is
  required. For running it, you need a latex distribution installed.
  If you already have Mactex or Basic Tex installed (for example
  the one you installed using `MacTeX.pkg`), you are ready to go!!
  **You don't need to install a specific Homebrew version of Mactex**.
  But if you don't have latex installed at all, you can install it using 
  `brew cask install mactex`.
- **How come there has never been an official formula for Homebrew?** This
  is mainly because of the complexity of auto-multiple-choice. It has an
  insane number of Perl dependencies (~70 packages). Perl dependencies are not
  handled by Homebrew (Macports does handle them), so I have to 'vendor'
  them (= install them only for auto-multiple-choice, not system-wide).
  The bad side is that it makes it a _long_ formula (678 loc) that you
  can compare to the [`ansible.rb`][ansible.rb] formula (557 lines, but for vendoring python
  packages).
- **When building from source, why are there so many Perl download/make/make install?**
  This is because Homebrew is not able to handle Perl dependencies, so I
  have to vendor each of the dependencies (around 70 of them), which means
  there are MANY downloads during the build phase if it is built from source.
- **When running, there is a dylib/dydl error** This is probably because it
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
  have Mactex (if you don't have it: `brew cask install mactex`).
- **Can I use the latest version (--devel, --HEAD) from mercurial?**
  At first, I had enabled the possibility for compiling using the
  `--HEAD` flag (so that it compiles using the latest sources from [mercurial]).
  But because it required latex during the build and that the compilation of
  the documentation and .sty was extremely cumbersome, I disabled it (allowing me
  to remove ~100 loc from the formula).
- **What are the next steps before publishing the formula to
  homebrew-core?** Two main problems before the maintainers of Homebrew can
  accept this formula into the core formulas: I rely on a pre-built
  `pdftk.pkg`. It is not allowed in Homebrew core. A source-code-based
  [PDFtk formula](https://github.com/spl/homebrew-pdftk) has existed for a
  while but the maintainer gave up as because of gcj-5 (from gcc@5
  --with-java) 'hanging' during the build (Macports [fixed
  gcc5](https://trac.macports.org/ticket/49227) just in order to build
  PDFtk). This is because PDFtk relies on GCJ which is dead by now. We
  could replace `pdftk` if we knew a way to scrap filled forms from PDFs.

[mercurial]: https://bitbucket.org/auto-multiple-choice/auto-multiple-choice
[uninstall-brew]: https://github.com/Homebrew/install
[ansible.rb]: https://github.com/Homebrew/homebrew-core/blob/master/Formula/ansible.rb
[issue-reduce-button]: https://github.com/maelvalais/homebrew-amc/issues/18

## Troubleshooting
- **Why are the windows _tabbed_ like in Safari tabs?**  because it is
  using Gtk3, pop-up windows (like _Open project_) are (weirdly) opening
  as tabbed windows. This is a work-in-progress on the GTK3 side; the
  workaround is to un-tab the window by dragging out the tab, or disable
  the [feature](https://support.apple.com/kb/PH25244?locale=en_US)
  (_System preferences_ -> _Dock_ -> _Prefer tabs when opening
  documents_).
- **`automultiplechoice.sty` is not found!** This file cannot be installed
  to your Mactex distribution during installation as it requires sudo. You
  must run this after installing:

        sudo auto-multiple-choice latex-link

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
  as a default dependency as Mactex is not installed during bottling. So we
  use the 'dist' tarballs from the Bitbucket's Downloads area which contain
  already compiled PDFs and documentation.

- **The application craches after closing a warning popup** The error is:

      Gdk:ERROR:gdkeventloop-quartz.c:567:select_thread_collect_poll: assertion failed:
      (ufds[i].events == current_pollfds[i].events)

  This bug seems to be related to Gtk+3 and Quartz backend used on macOS. I
  tried to [fix the issue][gtk-craches] but it does not seem easily
  reproducible so I gave up.

- **Why is there no nice icon nor AutoMultipleChoice.app?** Unfortunately,
  only deb-related linux distributions can (today) have a real _application_
  feel with a clickable icon in the application menu. On macOS, it would
  require to create an .app and sign it (which costs $99 per year). This is
  why we can only run it from the terminal and we don't get a fancy icon
  in the dock.

## Report issues

You can create an [issue] if you have any problem, question or if you
think the whole idea of a formula that vendors everything is insane.

[issues]: https://github.com/maelvalais/homebrew-amc/issues
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
