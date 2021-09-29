class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "846c0afac447626a6507f2492b82e07caefaf5a1c627fec8e49d280b9fd10df3"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.3"
    sha256 cellar: :any,                 big_sur:      "c6e8d720af33de45f672db1730cc14ad3a2f6dea726c5d3940101b0a96b5d75c"
    sha256 cellar: :any,                 catalina:     "227be8a191826c791d9984f74888edc80c6df80d8e2635749f30bdf0375d7575"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "348ed46cdd536e7dedbda8b2b512a9f265871044a520afaefc9424a1351f431e"
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
