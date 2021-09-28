class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "91335bf8e6cea56c6f105dda260a8cddacadbf9f5c50b9bdfc3473a87a7b0a1e"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.2"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "a222ec3b0b1b4bb5d7fb0493db8758854018ee46e2513a10284ef70daa8f2bdf"
    sha256 cellar: :any,                 catalina:     "ce109c95c035392bbd26b22d3b7429c24c780c90a567315e38f3701afacc15af"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "253869e9b74f3344441fcd32ab7b6d629507fe047638d9b3b67c3e17e981f711"
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
