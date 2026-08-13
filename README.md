# awaistechnologist/homebrew-tap

Homebrew formulae for [llm-sidecar](https://github.com/awaistechnologist/llm-sidecar).

```bash
brew install awaistechnologist/tap/llm-sidecar
llm-sidecar status
```

## Why a tap rather than pipx

Both work. The difference is PATH.

`pipx` installs to `~/.local/bin`, which macOS does not include by default — so
it edits your shell config, and that edit cannot reach a terminal that is
already open. The result is `command not found` immediately after a successful
install, which reads as a broken package.

Homebrew installs to `/opt/homebrew/bin`, already on PATH via `/etc/paths.d`.
The command works in the same terminal, first time.

Use pipx on Linux, or if you would rather not build a virtualenv through brew.

## Updating

```bash
brew update && brew upgrade llm-sidecar
```
