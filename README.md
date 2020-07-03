# 🍺 Brew formula for auto-multiple-choice 📖

<p align="center">
  <img width="420" alt="capture d ecran 2018-10-06 a 11 31 01" src="https://user-images.githubusercontent.com/2195781/46569894-26cddd00-c95c-11e8-9efd-6aa7fa3a6eb8.png">
  <img width="390" alt="capture d ecran 2018-10-06 a 11 23 47" src="https://user-images.githubusercontent.com/2195781/46569889-0867e180-c95c-11e8-98ad-969735cbb76f.png">
</p>

| Install                                         |                       Version                        |
| ----------------------------------------------- | :--------------------------------------------------: |
| `brew install maelvls/amc/auto-multiple-choice` | [![Stable bottle][stable-bottle-img]][stable-bottle] |

<!-- | `brew install maelvls/amc/auto-multiple-choice-devel` |  [![Devel bottle][devel-bottle-img]][devel-bottle]   | -->

- **To run it**: open [terminal](https://www.iterm2.com) and run `auto-multiple-choice`
- **For switching between the `devel` and `stable`**: see [below](#faq)

This tap aims to bring AMC ([homepage], [gitlab]) to Homebrew, an alternative to Macports
([portfile] for AMC).

~~This tap also features precompiled binaries (called _bottle_) built
on Travis CI. As for testing, a cron job runs tests the installation of the bottle on Travis
CI every night (as well as `brew linkage auto-mutiple-choice`) in order to
check that the bottle is still working.~~ For now the bottles are disabled (build time is 8 minutes
instead of 30 seconds) but it still works perfectly! (see below news)

[![Build Status][build-status-img]][build-status]

[build-status-img]: https://travis-ci.org/maelvls/homebrew-amc.svg?branch=master
[build-status]: https://travis-ci.org/maelvls/homebrew-amc
[stable-bottle-img]: https://img.shields.io/bintray/v/maelvalais/bottles-amc/auto-multiple-choice.svg?label=bottle
[stable-bottle]: https://bintray.com/maelvalais/bottles-amc/auto-multiple-choice/_latestVersion
[devel-bottle-img]: https://img.shields.io/bintray/v/maelvalais/bottles-amc/auto-multiple-choice-devel.svg?label=bottle
[devel-bottle]: https://bintray.com/maelvalais/bottles-amc/auto-multiple-choice-devel/_latestVersion
[gitlab]: https://gitlab.com/jojo_boulix/auto-multiple-choice
[homepage]: https://www.auto-multiple-choice.net/index.en
[portfile]: https://github.com/macports/macports-ports/blob/master/x11/auto-multiple-choice/Portfile

## News

### July 3, 2020: ⚠️ I don't have enough time to maintain bottles

To build bottles (= zipped version of the pre-built auto-multiple-choice formula), I use some
continous integration ([travis][build-status]). The builds have been failing for a while
now, and I can't find enough time to fix the while CI system or to move it to Github Actions
or to Azure Pipelines.

Until I find some time to make the CI work again (or if someone wants to help), I will remove
the bottles entirely. That means that the command `brew install auto-multiple-choice` will take
longer to install (~8 minutes instead of 30 seconds with the bottles), but at least it will work
all the time!

### Nov. 21th, 2019: Annotate & `Bad symbol syntax`

When using the 'annotation' feature, you may get errors like:

```
Bad symbol syntax: 0-1:circle/hex_red at /usr/local/Cellar/auto-multiple-choice/1.4.0_6/lib/AMC/perl/AMC-annotate.pl line 151.
```

or

```
No PDF directory: /Users/mvalais/Projets-QCM/toyP/cr/corrections/pdf at /usr/local/Cellar/auto-multiple-choice/1.4.0_6/lib/AMC/perl/AMC-annotate.pl line 178.
The file /Users/mvalais/Projets-QCM/toyP/cr/corrections/pdf does not exist.
```

It might be something off in the settings file `~/.AMC.d/cf.default.xml`. Please try to rename
it and re-open your project.

### Nov. 18th, 2019: Fixed Pango by fixing the version to 1.42.4

The bug of the '[stacked caracters when
annotating](https://github.com/maelvls/homebrew-amc/issues/33)' has been fixed
(see
[ticket](https://project.auto-multiple-choice.net/boards/4/topics/8855?r=8904#message-8904)).

<!--

```sh
brew extract pango --version 1.42.4 maelvls/amc
brew extract cairo maelvls/amc
```
-->

### Sep. 19th, 2019: Annotations bug and Pango version

Pango 1.14.4 introduces a bug that breaks annotations (see [issue](https://github.com/maelvls/homebrew-amc/issues/33)). The text is stacked at the beginning of each PDF:

![](https://user-images.githubusercontent.com/54452098/63615417-4a6d3680-c5b3-11e9-97cc-c153f0ed10d8.png)

With Pango 1.42.4, annotations should work. ~~Here is the workaround:~~ this
workaround isn't needed anymore!

```
brew unlink pango
brew install --build-from-source https://raw.githubusercontent.com/Homebrew/homebrew-core/a8ac7ea5/Formula/pango.rb
brew switch pango 1.42.4_2
```

### Aug. 27th, 2019: changed my username to `maelvls`, remove the useless devel version

If you get the error:

```
Error: Formulae found in multiple taps:
* maelvalais/amc/auto-multiple-choice-devel
* maelvls/amc/auto-multiple-choice-devel
```

To fix it:

```
brew untap maelvalais/amc
brew tap maelvls/amc
```

Regarding `auto-multiple-choice-devel`, it was used in pre-1.4.0 but right now it has
the same version as `auto-multiple-choice` and is useless. I removed the installation
information from the readme.

### Jan. 5th, 2019: opencv4 ~~breaks things~~ fixed ✅

`AMC-detect` and `AMC-buildpdf` rely on opencv3. When Homebrew moved to opencv4,
it broke the dynamic library linkages as well as makfiles (now `-std=c++11` is needed
and the header path is a bit different).

~~I'll fix that asap.~~ Fixed on Jan. 6th, 2019 with version `1.4.0_1`!
If you still have the `1.4.0` version, just `brew upgrade auto-multiple-choice`. You can do
`brew info auto-multiple-choice` to check the installed version.

### Dec. 30th, 2018: 1.4.0 released 🍾

Note that the `auto-multiple-choice-devel` will have the same version number
as `auto-multiple-choice` probably for the next few months; I'll update
`devel` as soon as new tags are created.

### Oct. 4th, 2018: 1.4.0-rc2 and auto-multiple-choice-devel formula

I was kind of frustrated at the fact that using `--devel` was taking a LOT of
time, and updating it was thus a pain. I decided to create a real formula
called `auto-multiple-choice-devel` that replaces the use of `--devel`. What's
nice is that you will get precompiled: way less waiting when installing!!!

To sum up:

1. **`--devel` won't work anymore**,
2. instead, use **`brew install auto-multiple-choice-devel`**.
3. `auto-multiple-choice` and `auto-multiple-choice-devel` cannot be linked at
   simultanously (obviously).

### July 5th, 2018: 1.4.0-rc1

I updated the `--devel` version with the latest release candidate.

### May 17th, 2018: try the coming 1.4.0-beta version!

You can enable the development version using:

    brew install maelvls/amc/auto-multiple-choice --devel

It will install the latest beta available. Note that due to Homebrew limitations,
bottles cannot be built for devel versions, resulting in a longer installation
time (it will need to download and install all the Perl dependencies).

### March 19th, 2018: Scan detection works again!

We fixed the above bug (see [PR53]). Everything should be back to normal in 1.3.0.2199.
~~Note that bottles won't be available for a couple of days, but it only means that
the installation will be slightly longer in the meantime!~~ done!

[pr53]: https://bitbucket.org/auto-multiple-choice/auto-multiple-choice/pull-requests/53/amc-detect-fix-errors-with-opencv-341-by

### March 15th, 2018: Fixed: ~~OpenCV breaks scan detection~~

Homebrew updated OpenCV from 3.4.0 to 3.4.1. In 3.4.0, the C headers of OpenCV used
in AMC were fine (athough they have been [deprecated](https://github.com/opencv/opencv/issues/6221)
for a long time now) but in 3.4.1 the function `cvLoadImage()` breaks. I'll see if we can move
away from the C bindings in `AMC-detect.cc` (which is the culprit, see
[the issue](https://github.com/maelvls/homebrew-amc/issues/4)) but that will take some
days and even more time for pushing that upstream.

### March 14th, 2018: build from source until March 17th

Homebrew has a bug that prevents me from creating bottles for a few days. I'll
re-enable the bottles as soon as brew [releases version 1.5.11](https://github.com/Homebrew/brew/releases).
Until then, we must build from source, meaning that many perl packages will be
downloaded and built during installation. Sorry for that!

### Febrary 3rd, 2018: brew update thows 'rebase' errors

⚠️ If you get the following error when Homebrew updates: ⚠️

```plain
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

    git -C $(brew --repo maelvls/amc) reset --hard origin/master

## FAQ

- **How to switch between the `devel` and stable version?** As both formulas
  are mutually exclusive, one must be **uninstalled** or **unlinked** before the other
  can be used. For example, from stable to devel:

      brew unlink auto-multiple-choice
      brew install auto-multiple-choice-devel

  Remember that for both formulas, the command is the same: `auto-multiple-choice`.
  **IMPORTANT:** You will need to run `latex-link` when switching versions:

      sudo auto-multiple-choice latex-link remove
      sudo auto-multiple-choice latex-link

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
  Two solutions: **1)** try reinstalling with `brew reinstall auto-multiple-choice`, **2)** build from source with `brew install auto-multiple-choice --build-from-source`. If you are still stuck, please
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
[issue-reduce-button]: https://github.com/maelvls/homebrew-amc/issues/18

## Troubleshooting

- **Why are the windows _tabbed_ like in Safari tabs?** because it is
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

- **The font _Linux Libertine_ is not found!** Install Libertine using brew:

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
  require to create an .app and sign it (which costs \$99 per year). This is
  why we can only run it from the terminal and we don't get a fancy icon
  in the dock.

## Report issues

You can create an [issue] if you have any problem, question or if you
think the whole idea of a formula that vendors everything is insane.

[issues]: https://github.com/maelvls/homebrew-amc/issues
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

I went to <http://deps.cpantesters.org> and I copy-pasted the tree of dependencies
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
