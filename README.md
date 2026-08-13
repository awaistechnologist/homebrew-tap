# awaistechnologist/homebrew-tap

> **Not recommended. Use `pipx install llm-sidecar` instead.**
>
> This tap works — it was built and installed successfully — but the cost is
> not worth paying. It is kept as a record of why, and archived.

## What happened

A Homebrew tap looked attractive because it lands binaries in
`/opt/homebrew/bin`, which is already on `PATH`. pipx installs to
`~/.local/bin`, which macOS does not include by default, so it edits your shell
config — and that edit cannot reach a terminal already open. The result is
`command not found` immediately after a successful install.

Solving that annoyance turned out to cost this:

```
llvm      1.9 GB
rust      440 MB
z3         33 MB
libgit2, libssh2, llhttp, libxml2, libxslt
──────────────────────────────────────────
2.2 GB of build toolchain, before compiling any of the 48 dependencies
```

Homebrew builds every resource from source. `pydantic-core`, `cryptography`,
`rpds-py` and `primp` are Rust, and Rust pulls in LLVM. The equivalent
`pipx install` takes about twenty seconds using prebuilt wheels and needs no
compiler at all.

## The other thing worth recording

`brew update-python-resources` cannot generate stanzas for a release published
in the last 24 hours: it injects pip's `--uploaded-prior-to=P1D` and then
reports the package does not exist. That gate lives in the generator, not in a
formula — the 48 stanzas here were written straight from the PyPI JSON API and
build fine. Useful to know if you hit the same wall on another project.

## Conclusion

Homebrew suits a single self-contained binary — Go, Rust, C. For a Python
application with dozens of compiled dependencies, pipx is the right tool, and
one `source ~/.zshrc` is a smaller price than 2.2 GB and a source build on
every release.
