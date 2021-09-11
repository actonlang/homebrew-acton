class Acton < Formula
  desc "The Acton Programming Language"
  homepage "https://acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5ccc7244857e6aa461f65560ed06ada768521b37b22d20843839593336415577"
  head "https://github.com/actonlang/acton.git", branch: "brew"
  license "BSD-3-Clause"

  depends_on "argp-standalone" => :build
  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "util-linux" => :build

  def install
    ENV.deparallelize
    system "make"
    bin.install "dist/bin/actonc"
    prefix.install Dir["dist/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test acton`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
