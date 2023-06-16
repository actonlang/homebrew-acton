class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "cc885025e9eeb20aad86bf8e28e9161a62934999feeb6bd8876488a77751269f"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.15.2"
    sha256 cellar: :any_skip_relocation, ventura:  "09e2541ef6d3cfc474d57730749f66a0b83073e92b3af4d0a444a78f9e095581"
    sha256 cellar: :any_skip_relocation, monterey: "9aaea2d77fbc8d84e7187bb7eb867e0310df104163b03c9be0b1a88ce3db8817"
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
