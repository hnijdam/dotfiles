# Windows/WSL Hybrid Installer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Route dotfile installation safely between native Windows, WSL, and Linux while asking WSL users only for their tooling scope.

**Architecture:** Chezmoi filters platform-specific source directories using the native OS value. Bash installation scripts identify WSL at runtime and select a minimal or development package set. The existing PowerShell installer remains native-Windows-only. Documentation becomes the explicit bootstrap entry point for each terminal.

**Tech Stack:** Chezmoi templates, Bash, PowerShell, shell test harness.

**Spec:** `docs/superpowers/specs/2026-11-15-windows-wsl-hybrid-installer-design.md`

## Global Constraints

- Native Windows executes only PowerShell installation scripts.
- WSL executes only Linux scripts and must never invoke Scoop, PowerShell, or Flatpak desktop installation.
- WSL asks once for base CLI versus development tooling; non-interactive runs default to base CLI.
- Fedora and macOS routing remains unchanged.
- README commands must be terminal-specific and copy-pasteable.

## Review Focus

- WSL detected solely through kernel information still selects the WSL route; cover in Task 1.
- A non-interactive WSL run does not block on input and installs only base tools; cover in Task 1.
- A user selecting development tooling receives both base and development packages; cover in Task 1.
- Linux hosts without WSL variables retain their existing package-manager route; cover in Task 1.
- Chezmoi on each supported OS excludes incompatible platform scripts; cover in Task 2.

---

### Task 1: WSL-aware Unix package routing

**Files:**
- Modify: `run_once_install-packages.sh`
- Modify: `run_once_install-devtools.sh`
- Create: `tests/test_unix_installers.sh`

**Interfaces:**
- Consumes: `WSL_DISTRO_NAME`, `WSL_INTEROP`, stdin, package-manager commands.
- Produces: a single WSL installation path that runs base packages always and development packages only after explicit selection.

- [ ] **Step 1: Write failing shell tests for WSL detection and package selection**

Test `WSL_DISTRO_NAME`, `WSL_INTEROP`, and mocked kernel-release detection; assert no `flatpak`, `pwsh`, or `scoop` invocation. Assert non-interactive default is base-only and explicit `development` selection includes the development package set.

- [ ] **Step 2: Run the installer tests to verify they fail**

Run: `bash tests/test_unix_installers.sh`
Expected: FAIL because the current installers do not expose or follow the WSL selection contract.

- [ ] **Step 3: Implement the WSL detector and selection flow**

Add `is_wsl() -> exit status` and a TTY-safe selection function in `run_once_install-packages.sh`; make `run_once_install-devtools.sh` use the recorded selection rather than unconditionally installing development packages in WSL. Keep existing Fedora, rpm-ostree, and non-WSL Debian behavior unchanged.

- [ ] **Step 4: Run the installer tests to verify they pass**

Run: `bash tests/test_unix_installers.sh`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add run_once_install-packages.sh run_once_install-devtools.sh tests/test_unix_installers.sh
git commit -m "feat: route WSL installers safely"
```

### Task 2: Chezmoi platform routing

**Files:**
- Modify: `.chezmoiignore`
- Create: `tests/test_chezmoi_platform_routing.sh`

**Interfaces:**
- Consumes: `chezmoi execute-template` with `chezmoi.os` values.
- Produces: Windows, Linux, and macOS each receive only their matching platform-script directory.

- [ ] **Step 1: Write failing template-routing tests**

Render `.chezmoiignore` for `windows`, `linux`, and `darwin`; assert the actual `scripts/<platform>/**` paths—not the stale `.chezmoiscripts` paths—are selected.

- [ ] **Step 2: Run the routing tests to verify they fail**

Run: `bash tests/test_chezmoi_platform_routing.sh`
Expected: FAIL because the current ignore patterns name a directory that does not exist.

- [ ] **Step 3: Correct `.chezmoiignore` source-directory patterns**

Replace `.chezmoiscripts/<platform>/**` with the actual `scripts/<platform>/**` paths while retaining the intended Windows/Linux/macOS conditions.

- [ ] **Step 4: Run the routing tests to verify they pass**

Run: `bash tests/test_chezmoi_platform_routing.sh`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add .chezmoiignore tests/test_chezmoi_platform_routing.sh
git commit -m "fix: filter dotfile scripts by platform"
```

### Task 3: Native Windows guard and bootstrap documentation

**Files:**
- Modify: `scripts/windows/run_once_install-devtools-windows.ps1`
- Modify: `README.md`
- Create: `tests/test_windows_bootstrap.ps1`

**Interfaces:**
- Consumes: Windows environment detection and the documented terminal context.
- Produces: a clear native-PowerShell-only failure message and separate Windows, WSL, and Linux bootstrap instructions.

- [ ] **Step 1: Write a failing PowerShell guard test**

Assert the installer rejects non-`Windows_NT` execution before changing environment state, and that its error explicitly directs WSL users to the Linux bootstrap.

- [ ] **Step 2: Run the PowerShell test to verify it fails**

Run: `pwsh -NoLogo -NoProfile -File tests/test_windows_bootstrap.ps1`
Expected: FAIL because the present error text does not give the terminal-specific bootstrap route.

- [ ] **Step 3: Update the PowerShell guard and README**

Keep the current `Windows_NT` check, improve its message, and split README setup into native PowerShell, WSL, and Linux sections. Document how a WSL user later opts into development tooling.

- [ ] **Step 4: Run documentation and PowerShell checks**

Run: `pwsh -NoLogo -NoProfile -File tests/test_windows_bootstrap.ps1 && rg -n "PowerShell|WSL|Linux" README.md`
Expected: PowerShell test passes and README contains all three explicit routes.

- [ ] **Step 5: Commit**

```bash
git add scripts/windows/run_once_install-devtools-windows.ps1 README.md tests/test_windows_bootstrap.ps1
git commit -m "docs: clarify Windows and WSL bootstrap"
```

### Task 4: End-to-end dry-run verification

**Files:**
- Modify: `README.md` only if verification reveals a command discrepancy.

**Interfaces:**
- Consumes: local Chezmoi installation and all three test scripts.
- Produces: a verified bootstrap path without modifying user dotfiles.

- [ ] **Step 1: Run all script tests**

Run: `bash tests/test_unix_installers.sh && bash tests/test_chezmoi_platform_routing.sh && pwsh -NoLogo -NoProfile -File tests/test_windows_bootstrap.ps1`
Expected: PASS.

- [ ] **Step 2: Run Chezmoi dry-run verification**

Run: `chezmoi apply --dry-run --verbose`
Expected: Chezmoi reports planned operations without applying files or executing package installation.

- [ ] **Step 3: Review the working tree and commit any documentation correction**

Run: `git diff --check && git status --short`
Expected: no whitespace errors; only intended files changed.
