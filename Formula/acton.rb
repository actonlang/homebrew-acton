class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "5b0281074504caaba2ac3d95d507ffdb1fad9d0ce27196fce375dfcf6205eeff"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.15.3"
    sha256 cellar: :any_skip_relocation, ventura:      "abc9632f2eced75edc9ce96e7ebbe68e6dd46cb8a63ce1491607cd7184839082"
    sha256 cellar: :any_skip_relocation, monterey:     "19231ae0f3c663d16cb5e0f7c3f2888b3344c881cf645b824f3fbd7f2a59264f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c61a62b7ab081a208f3ffe39a2cfb09fae2fb4e967feef1569019fef13f87a9c"
  end

  # TODO: can gettext be removed? it was likely necessary when we built deps
  # using autoconf, but might not be needed now that we use build.zig?
  depends_on "gettext" => :build
  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build

  on_linux do
    depends_on "gmp"
  end

  def install
    # Fix up stack config to not install project local GHC
    inreplace "compiler/stack.yaml", "# system-ghc: true", <<~EOS
      system-ghc: true
      install-ghc: false
      allow-newer: true
    EOS

    ENV["BUILD_RELEASE"] = "1"
    system "make"
    bin.install "dist/bin/actonc"
    bin.install "dist/bin/actondb"
    bin.install "dist/bin/runacton"
    prefix.install Dir["dist/*"]
    bash_completion.install "completion/acton.bash-completion"
  end

  test do
    testapp = (testpath/"hello.act")
    testapp.write <<~EOS
      #!/usr/bin/env runacton
      actor main(env):
          print("Hello World!")
          await async env.exit(0)
    EOS
    testapp.chmod 0755
    assert_equal "Hello World!\n", shell_output(testapp)
  end
end
