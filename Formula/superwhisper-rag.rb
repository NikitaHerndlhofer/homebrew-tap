class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.2.0/swrag-darwin-arm64.tar.gz"
      sha256 "fcafde9b63a6e54d5ae8d8935808a45b8b2e5854ac62574c0958c3e8577ba275"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.2.0/swrag-darwin-x64.tar.gz"
      sha256 "35fd144cffc80544dbecaae41c45c5660856ce3b2afcdf1d10d8194ad668759e"
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
    assert_match(/0\.1\.0/, shell_output("#{bin}/swrag --version"))
  end
end
