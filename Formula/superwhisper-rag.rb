class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.4.0/swrag-darwin-arm64.tar.gz"
      sha256 "9ab4e68eaa8450df78571a43e0b2a7c9fff4a206d81f9b0a0ab7dbddc4997051"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.4.0/swrag-darwin-x64.tar.gz"
      sha256 "96cf3bc3d32fdb19daff4f7cea2cfa711a47e8029a1adbf3a9933136eca3c6be"
    end
  end

  depends_on "sqlite"
  depends_on "ollama" => :recommended

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "swrag-darwin-#{arch}" => "swrag"
  end

  def caveats
    <<~EOS
      The archive is auto-created on first use at
        ~/Library/Application Support/superwhisper-rag/swrag.sqlite

      To use semantic search:
        ollama pull bge-m3

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
