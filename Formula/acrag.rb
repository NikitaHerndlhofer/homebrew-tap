class Acrag < Formula
  desc "Local SQL archive for your agentic coding chat history (Cursor first)"
  homepage "https://github.com/NikitaHerndlhofer/acrag"
  version "0.4.0"
  license "MIT"

  depends_on "ollama"
  depends_on "sqlite"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.4.0/acrag-darwin-arm64.tar.gz"
      sha256 "c94e9a63dc41b411dee160813173cd3d88ed75fc8bd84ee8cb885098044ea712"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.4.0/acrag-darwin-x64.tar.gz"
      sha256 "37d484836fd51a67bd986cd69a8d19c34b0366436756e4ab42bf12c496814dbf"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "acrag-darwin-#{arch}" => "acrag"
  end

  def caveats
    <<~EOS
      Finish setup (interactive wizard — pulls the model, migrates, prompts to
      install Cursor hooks + skill, and indexes your existing chats):
        acrag bootstrap

      The archive is auto-created at
        ~/.acrag/acrag.sqlite

      acrag indexes your Cursor chats straight from Cursor's on-disk database
      (~/Library/Application Support/Cursor/User/globalStorage/state.vscdb),
      read-only — it never modifies the Cursor DB. Override the path with
      ACRAG_CURSOR_DB.

      `acrag bootstrap` pulls bge-m3 (~2 GB, one-time) automatically when
      missing, and prompts (Y/n) to install:
        - Cursor hooks  -> ~/.cursor/hooks.json
          (fires `acrag` on stop / subagentStop / subagentStart / workspaceOpen;
          detached background ingest so the agent never blocks)
        - the agent skill -> ~/.cursor/skills/acrag/SKILL.md
          (manual-invocation only — type @acrag in Cursor; the agent cannot
          reach for it autonomously)
      Each step is idempotent and skipped when already done; re-run any time.

      Each step is independently invokable too:
        acrag index             # index Cursor chats from state.vscdb, on-disk
                                #   agent-transcripts/**/*.jsonl (sqlite-wins
                                #   backfill), and generic *.jsonl
        acrag ingest-cursor <id>  # re-ingest one Cursor conversation
        acrag install-hooks     # (re)write/merge ~/.cursor/hooks.json
        acrag install-skill     # (re)write the SKILL.md
        acrag sql               # pipe SQL (vec preloaded, archive read-only)
        acrag embed             # pipe text -> vec blob literal for vec_search
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/acrag --version"))
  end
end
