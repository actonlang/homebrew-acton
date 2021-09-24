class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "73bc04088ab6126a7ac3a0489113c3501646508784c536be3cea8c0c8e577481"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.2"
    sha256 cellar: :any,                 big_sur:      "b8d6e5879da4194c6b05d47422a9bbe2c3e594c4d85572bfb1f4b7518b4ef1cf"
    sha256 cellar: :any,                 catalina:     "6f18f86a51d0a7e40bda9bd1541027648977682895b341cafe4b0253c81ad5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "672073caf77307660327163f2db22df28bf07eb9ca6f00951fe61ac0c951e7a9"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "utf8proc" => :build

  depends_on "protobuf-c"
  depends_on "util-linux"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  on_linux do
    depends_on "gmp"
    depends_on "libbsd" => :build
  end

  def install
    ENV.deparallelize
    system "make"
    bin.install "dist/bin/actonc"
    bin.install "dist/bin/actondb"
    prefix.install Dir["dist/*"]
  end

  test do
    # For Homebrew/homebrew-core this will need to be a test that verifies the
    # functionality of the software. Run the test with `brew test acton`.
    # Options passed to `brew install` such as `--HEAD` also need to be
    # provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
