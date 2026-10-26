# homebrew-tap

Homebrew tap for my tools.

## Available formulae

| Formula    | What it is                                                                                                                          | Source                                          |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `memindex` | Universal local search archive with plugins (Super Whisper, Cursor, Claude Code). Postgres + pgvector, multilingual bge-m3 via Ollama. | <https://github.com/NikitaHerndlhofer/memindex> |

## Install

```sh
brew install nikitaherndlhofer/tap/memindex
memindex install
```

`superwhisper-rag` and `acrag` were merged into `memindex`; both old names install it, and `brew upgrade` moves existing installs over.
