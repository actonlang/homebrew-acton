class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "aeacfe6ca13d8a7d8f41fddc944e3ca421448c9ebe68b3d10772664430a9b0ef"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.0"
    sha256 cellar: :any, big_sur:  "654320bf38d4f43670ea49a064acec825f06d4fcf0df9cbed90a78cef0e72d93"
    sha256 cellar: :any, catalina: "bbc2454ec407628b55350c502066a1dc21502d4aa623294dbc299336e2f24b21"
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
