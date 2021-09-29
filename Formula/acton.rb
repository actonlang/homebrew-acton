class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "846c0afac447626a6507f2492b82e07caefaf5a1c627fec8e49d280b9fd10df3"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.4"
    sha256 cellar: :any,                 big_sur:      "9e56ae56925c053e260aae55b954d6e579f36a5c52f76abf2be35037ce9719ed"
    sha256 cellar: :any,                 catalina:     "0fd1464269d3f2140987e4e69c27ccfd9f68eec225d20dd1e05f39175e2b22d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e1f17a4d512c7ca2ce63207aa1e045e398bde2667233d73a78aecbc7752d223"
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
    depends_on "gcc"
    depends_on "gmp"
    depends_on "libbsd" => :build
  end

  def install
    ENV["BUILD_RELEASE"] = "1"
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
