# Public Windows and WSL Bootstrap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver public, platform-correct first-installation entry points for Windows and WSL, including GitHub CLI and VS Code/Emacs defaults.

**Architecture:** Public PowerShell and Bash bootstrap scripts install the tools needed before ChezMoi can clone the repository. Existing ChezMoi hooks provide package installation after apply, with a WSLg branch for Linux GUI editors.

**Tech Stack:** PowerShell, Bash, DNF, APT, Scoop, ChezMoi.

**Spec:** `docs/superpowers/specs/2026-11-15-public-windows-wsl-bootstrap-design.md`

## Global Constraints

- Never execute Bash scripts from native Windows or PowerShell scripts from WSL.
- Install `gh`, VS Code, and Emacs by default on supported platforms.
- WSL GUI editors require WSLg; do not install an external X server.
- WSL excludes Scoop, Flatpak, and Windows-only tooling.
- The public repository bootstrap must not require credentials.

## Review Focus

- Fedora WSL with only `WSL_INTEROP` set must use DNF and not desktop Flatpak tooling.
- Ubuntu/Debian WSL must use APT and use the correct `clang-tools` package.
- WSL without WSLg must skip, rather than attempt, GUI editor installation.
- Native Windows must contain no Bash bootstrap command.
- Public bootstrap must work when `XDG_RUNTIME_DIR` is inaccessible.

---

### Task 1: Public platform bootstrap scripts

**Files:**
- Create: `bootstrap/bootstrap-linux.sh`
- Create: `bootstrap/bootstrap-windows.ps1`
- Create: `tests/test_public_bootstrap.sh`
- Create: `tests/test_public_bootstrap.ps1`

- [ ] Write failing tests for platform guards, package-manager selection, `gh`, and the `XDG_RUNTIME_DIR`-free ChezMoi call.
- [ ] Implement minimal Bash and PowerShell bootstrap scripts.
- [ ] Run the tests and commit `feat: add public platform bootstraps`.

### Task 2: WSLg editor provisioning

**Files:**
- Modify: `run_once_install-packages.sh`
- Modify: `run_once_install-devtools.sh`
- Modify: `tests/test_installer_routing.sh`

- [ ] Write failing tests for WSLg and non-WSLg editor behavior.
- [ ] Implement DNF/APT editor installation with WSLg detection; preserve non-WSL Linux behavior.
- [ ] Run the full shell test suite and commit `feat: install WSLg editors by default`.

### Task 3: Terminal-specific documentation

**Files:**
- Modify: `README.md`

- [ ] Document copy-paste PowerShell and Linux/WSL bootstrap URLs, WSLg requirement, and `gh auth login` as optional post-bootstrap setup.
- [ ] Verify commands point to public source files and run documentation checks.
- [ ] Commit `docs: document public Windows and WSL bootstrap`.

### Task 4: End-to-end verification

**Files:**
- Modify: none unless verification finds a documentation mismatch.

- [ ] Run all shell and PowerShell tests, Bash syntax checks, ChezMoi Windows rendering, and `git diff --check`.
- [ ] Review the complete diff and request an independent code review.
