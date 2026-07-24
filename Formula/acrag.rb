class Acrag < Formula
  desc "Local SQL archive for your agentic coding chat history (Cursor first)"
  homepage "https://github.com/NikitaHerndlhofer/acrag"
  version "0.3.0"
  license "MIT"

  depends_on "ollama"
  depends_on "sqlite"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.3.0/acrag-darwin-arm64.tar.gz"
      sha256 "53e301801dafc92f3d5429b073eb21721f89362c0942a569b546bfa7c041115a"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.3.0/acrag-darwin-x64.tar.gz"
      sha256 "ebcc8e0288625543b38a4469ae8e36446a436311268b3d069c414c754654728f"
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
        acrag index             # index Cursor chats from state.vscdb (+ *.jsonl)
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
