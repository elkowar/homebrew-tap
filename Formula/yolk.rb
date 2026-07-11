class Yolk < Formula
  desc "Templated dotfile management without template files"
  homepage "https://elkowar.github.io/yolk"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elkowar/yolk/releases/download/v1.3.0/yolk_dots-aarch64-apple-darwin.tar.xz"
      sha256 "1f071b259418e58518156c66c24d4757bb9b36e22550376d20b2669c110f08f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elkowar/yolk/releases/download/v1.3.0/yolk_dots-x86_64-apple-darwin.tar.xz"
      sha256 "02701b041414f785c6e7e6a513ec660db4b826a45c4707e50e5bcdd11001baad"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/elkowar/yolk/releases/download/v1.3.0/yolk_dots-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e78bec5d1121e02fb6bb656ba20b3f5ac0df93cc9a1d8eb86cb466c3998e11f9"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-linux-android":             {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "yolk" if OS.mac? && Hardware::CPU.arm?
    bin.install "yolk" if OS.mac? && Hardware::CPU.intel?
    bin.install "yolk" if OS.linux? && Hardware::CPU.intel?
    generate_completions_from_executable(bin/"yolk", shell_parameter_format: :clap)

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
