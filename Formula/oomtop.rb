# Homebrew formula for oomtop. Rendered from packaging/homebrew/oomtop.rb.tmpl by packaging/homebrew/render.py
# (release workflow + tools/release/update-tap.sh) and committed to the tap iprajax/homebrew-oomtop as
# Formula/oomtop.rb. Install: brew install iprajax/oomtop/oomtop   (homebrew-core submission after 1.0, SPEC §16)
class Oomtop < Formula
  desc "Memory accounting, attribution and headroom for local AI work"
  homepage "https://github.com/iprajax/oomtop"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # One universal (arm64 + x86_64) archive serves both Mac architectures; brew style only allows url/sha256
  # inside the innermost on_arm/on_intel blocks.
  on_macos do
    on_arm do
      url "https://github.com/iprajax/oomtop/releases/download/v0.1.0/oomtop-0.1.0-universal-apple-darwin.tar.gz"
      sha256 "8a1301cf1b50c34c92002b1c01017f6294db3e254f0e2cd32373a223c1846e40"
    end
    on_intel do
      url "https://github.com/iprajax/oomtop/releases/download/v0.1.0/oomtop-0.1.0-universal-apple-darwin.tar.gz"
      sha256 "8a1301cf1b50c34c92002b1c01017f6294db3e254f0e2cd32373a223c1846e40"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/iprajax/oomtop/releases/download/v0.1.0/oomtop-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f84a84578605b24ad2d18934c70ac9aaf0ce05321f41bdc200b9c17b8a8f418b"
    end
    on_arm do
      url "https://github.com/iprajax/oomtop/releases/download/v0.1.0/oomtop-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5bf5a795d40e9aaeccbc6255d7b49dc1c68bce9b5523fa78c86eb765ac1bc83"
    end
  end

  def install
    bin.install "oomtop"
    doc.install "README.md", Dir["docs/*.md"]
  end

  def caveats
    <<~EOS
      Use it from Claude Code (MCP, read-only by default):
        claude mcp add oomtop -- #{opt_bin}/oomtop mcp
      Configuration: oomtop config init   (writes ~/.config/oomtop/config.toml)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oomtop --version")
    # Sandbox-safe: prints the commented default config to stdout, touches no files and no other process.
    assert_match "theme", shell_output("#{bin}/oomtop config init --print")
    system bin/"oomtop", "keys", "list", "--conflicts"
  end
end
