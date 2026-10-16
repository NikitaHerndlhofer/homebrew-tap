class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "1.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v1.3.2/swrag-darwin-arm64.tar.gz"
      sha256 "794d4b4eb89af0af36318d7bd27359e8df88dbb073b805f6e49675b06a2fd43a"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v1.3.2/swrag-darwin-x64.tar.gz"
      sha256 "b69b5d0c8ce49271b028f430a073871a688cef3077b61bdbadd37c41dcefc17b"
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
