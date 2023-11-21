class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "b8b941f777232f35b79308f70dbc8f43ab3727aab29a2067bf905924656e72e7"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.18.3"
    sha256 cellar: :any_skip_relocation, ventura:      "e394cbeda76fc2e67ee0d555246ed8c1da35a97ab1c8f10af32a6ae4e00f46dc"
    sha256 cellar: :any_skip_relocation, monterey:     "61542c9ab1717ee269c7f0b20fd612d3ede783bca38e288d9560ce31ac227930"
    sha256                               x86_64_linux: "7a6b730367bb8ffdd545be3c50fa02226c1d11649c2bd23ee90ad68a8207e749"
  end

  depends_on "ghc@9.4" => :build
  depends_on "haskell-stack" => :build

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
          env.exit(0)
    EOS
    testapp.chmod 0755
    assert_equal "Hello World!\n", shell_output(testapp)
  end
end
