class AmcGobjectIntrospection < Formula
  include Language::Python::Shebang

  # I had to vendor Gobject-introspection in order to fix segfaults happening on
  # Apple Silicon due to g_callable_info_prepare_closure. See:
  # https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/301
  # This vendoring can be removed as soon as gobject-introspection 1.72 is
  # released and its Homebrew formula is updated.

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://github.com/maelvls/gobject-introspection/archive/refs/tags/1.70.0-16-g366a886b.tar.gz"
  sha256 "6f31219c9c2678d488725ce3dd94e65ef7110ce6191c68d911b09f8b55880856"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 0

  bottle do
    root_url "https://github.com/maelvls/homebrew-amc/releases/download/amc-gobject-introspection-1.70.0-16"
    sha256 big_sur:  "d2b76a071979b875f3f7d6f93303a5ec977fe1feb68104fc55688fcb5f49fbda"
    sha256 catalina: "a51d3e0fe5787a0429518a2848e9d5729a05558f1e7d17b40057aa3ca27a965c"
  end

  keg_only "vendored version of Homebrew's gobject-introspection"

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        revision: "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpython=#{Formula["python@3.9"].opt_bin}/python3",
        "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
        ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      bin.find { |f| rewrite_shebang detected_python_shebang, f }
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["amc-gobject-introspection"].opt_lib/"pkgconfig"
    ENV.prepend_path "PATH", Formula["amc-gobject-introspection"].opt_bin.to_s
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
