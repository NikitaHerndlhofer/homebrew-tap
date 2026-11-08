class Memindex < Formula
  desc "Universal local search archive with plugins: Super Whisper, Cursor, Claude Code"
  homepage "https://github.com/NikitaHerndlhofer/memindex"
  version "0.2.1"
  license "MIT"

  depends_on "ollama"
  depends_on "supabase"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.2.1/memindex-darwin-arm64.tar.gz"
      sha256 "ccd25cb54e8dbbb0446ab2fb374b2b4752e709e322bbe13b414f79ef0f6400a6"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.2.1/memindex-darwin-x64.tar.gz"
      sha256 "fece0c3bfa6a4565804ec50f0ce44169b2a94778e6cbba16abc009fb17e47b2f"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "memindex-darwin-#{arch}" => "memindex"
  end

  def caveats
    <<~EOS
      memindex needs a Postgres database with pgvector >= 0.8, pg_trgm,
      unaccent and btree_gin: a Supabase project or any Postgres you run.
      For a local one, the repository ships a docker-compose.yml:
        docker compose up -d   # then use postgres://memindex:memindex@127.0.0.1:54329/memindex

      Finish setup (checks the database and migrates it, pulls bge-m3 into
      Ollama, installs the background watcher, agent hooks and skill):
        memindex install

      The watcher runs as a low-priority background process. Embedding runs
      in short slices and waits while the Mac is on battery.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memindex --version")
  end
end
