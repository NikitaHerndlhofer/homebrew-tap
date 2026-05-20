class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.6.0/swrag-darwin-arm64.tar.gz"
      sha256 "4f0d12ec6b30a5e5bc9be3a07067ba888940d9e6f6ad2161591b37ce89aa3a7e"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.6.0/swrag-darwin-x64.tar.gz"
      sha256 "add04528b7b93e989d43ced231d7c48433690b2ff8a1105dc023a868f7634a1f"
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
