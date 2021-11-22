class Acton < Formula
  desc "Awesome Programming Language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "846c0afac447626a6507f2492b82e07caefaf5a1c627fec8e49d280b9fd10df3"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.4"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "24f4c11f795777061c3680c295441ed3b78b4455f64f0f56202eb6f8ca33d79b"
    sha256 cellar: :any,                 catalina:     "d13773e06967fa37ae4d2e054e9c4f2a5327ddad35fc6e0f5fffc39d58922b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "025ea6a3c29ba4a6e32eed2bda335e466965d56637bddac94152186755172e76"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  depends_on "protobuf-c"
  depends_on "utf8proc"
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
