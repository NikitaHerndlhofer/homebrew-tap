class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "1.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v1.1.1/swrag-darwin-arm64.tar.gz"
      sha256 "6106d7c38e9b3fa0ec6f80735ed34098647d37d288fd88f6514770d99e1d436d"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v1.1.1/swrag-darwin-x64.tar.gz"
      sha256 "3d6dc781e16522e16fc8dca8d20c4f63aa5e96f4f3c248669fb5fe15520ff392"
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
      Run once to finish setup (starts ollama, pulls the embed model,
      migrates from any v0.9.x install, installs the event-driven
      watch agent, indexes your archive, installs the agent skill,
      and verifies):
        swrag bootstrap

      The archive is then auto-created on first use at
        ~/Library/Application Support/superwhisper-rag/swrag.sqlite

      v1.0 replaces the pre-v0.7 hourly sync cron with a single
      FSEvents-based watch daemon (com.superwhisper-rag.watch) that
      ingests new Super Whisper recordings within ~2 seconds. If you
      were on v0.9.x, `swrag bootstrap` removes the legacy
      meeting-pipeline launchd plists automatically.

      Each bootstrap step is independently invokable too:
        swrag index             # ingest from Super Whisper
        swrag enable-watch      # install the launchd watch agent
        swrag install-skill     # ~/.cursor/skills + ~/.claude/skills
                                #  (manual-invocation only; the agent
                                #  cannot reach for it autonomously)
        swrag doctor
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/swrag --version"))
  end
end
