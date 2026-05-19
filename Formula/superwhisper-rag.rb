class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.5.0/swrag-darwin-arm64.tar.gz"
      sha256 "9c6e741214ddb051401ced436dd524304704094ece5c8fa1fc31e6158a6d45f3"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.5.0/swrag-darwin-x64.tar.gz"
      sha256 "cc732ba807ae241fe855fee9b1f70210f34825fc8aaf4a850dcecfb81434cb07"
    end
  end

  depends_on "sqlite"
  depends_on "ollama"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "swrag-darwin-#{arch}" => "swrag"
  end

  def caveats
    <<~EOS
      Run once to finish setup (starts ollama, pulls the embed model, verifies):
        swrag bootstrap

      The archive is then auto-created on first use at
        ~/Library/Application Support/superwhisper-rag/swrag.sqlite

      Optional, entirely opt-in:
        swrag enable-sync                # hourly background sync
        swrag install-skill              # ~/.cursor/skills + ~/.claude/skills
                                         # (manual-invocation only; the agent
                                         #  cannot reach for it autonomously)
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/swrag --version"))
  end
end
