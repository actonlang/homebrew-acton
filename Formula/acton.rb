class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "0b2c336a1de9e16170dc90dc2e19ccefe9f3ae5ecaf2d09eabdae70481f1c28e"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.18.0"
    sha256 cellar: :any_skip_relocation, ventura:      "9fe43813a959c09a0cd0307c09be44b9e36e3086e2acf3946fa61277a63e0a70"
    sha256 cellar: :any_skip_relocation, monterey:     "23271a54abfa12940c4147a23631a3377540d40e36c73d08a17b8421f3d5c9af"
    sha256                               x86_64_linux: "378737ac846489752cd1f9c3ee5e83734e78dbe88b76b4818dfba286895a8b4a"
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
