class LlmSidecar < Formula
  include Language::Python::Virtualenv

  desc "Local sidecar giving any tool grounded, cited, routed AI"
  homepage "https://github.com/awaistechnologist/llm-sidecar"
  url "https://files.pythonhosted.org/packages/eb/e6/2ded4cdef0dc23ba0396166938cbc4204caf18e3efeed7704ed9ffdf8c38/llm_sidecar-0.5.2.tar.gz"
  sha256 "da4967ead92edfc37dfff0061d6756ccffa94872cc1665d2ec341265b1b37e33"
  license "MIT"

  depends_on "python@3.13"

  # Dependencies are resolved by pip at install time rather than pinned as
  # `resource` stanzas.
  #
  # The strict approach means ~50 stanzas, several of which (pydantic-core,
  # cryptography, lxml) build from source and would pull a Rust toolchain into
  # every install. homebrew-core requires that and would reject this formula;
  # a personal tap does not, and the trade — a network fetch during install,
  # for a tool whose entire purpose is talking to networks — is worth it here.
  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install "llm-sidecar==#{version}"
    bin.install_symlink libexec/"bin/llm-sidecar"
  end

  def caveats
    <<~EOS
      llm-sidecar needs something to route to: either Ollama, or an OpenRouter key.

        brew install ollama && ollama pull llama3.2:3b
        llm-sidecar config key sk-or-... --save

      Then, to keep it running:

        llm-sidecar service install

      See what it can reach:  llm-sidecar status
    EOS
  end

  test do
    # `status` exits non-zero when there is nothing to route to, which is the
    # case on a clean CI machine — so assert on what it reports, not the code.
    output = shell_output("#{bin}/llm-sidecar status 2>&1", 1)
    assert_match "budget", output
    assert_match version.to_s, output

    assert_match "usage:", shell_output("#{bin}/llm-sidecar --help")
  end
end
