# Windows/WSL Hybrid Installer Design

## Intent

Make the dotfiles bootstrap unambiguous across native Windows, WSL, and Linux.
Native Windows must use PowerShell only; WSL must use Linux scripts only.

## Goals

- Detect native Windows, WSL, and ordinary Linux before platform-specific work.
- In WSL, offer a one-time choice between a base CLI installation and development tooling.
- Do not install Scoop or execute PowerShell scripts from WSL.
- Do not install Flatpak desktop applications in WSL.
- Make the correct terminal and bootstrap command explicit in the README.

## Non-goals

- No Windows desktop application installation from WSL.
- No automatic conversion between PowerShell and shell scripts.
- No change to the existing Fedora or macOS package selections outside platform routing.

## Approaches

1. Fully automatic routing removes all choices, but cannot express a WSL user's tooling preference.
2. An unconditional menu is visible but permits selecting an incompatible platform.
3. The selected hybrid approach detects the host first and prompts only for WSL tooling scope. It preserves safe automatic routing while allowing the one meaningful choice.

## Design

Chezmoi's native operating-system value routes Windows scripts and Unix scripts. The ignore rules must target the actual `scripts/windows`, `scripts/linux`, and `scripts/darwin` source directories.

The Unix package installer identifies WSL with `WSL_DISTRO_NAME`, `WSL_INTEROP`, or the kernel release. In WSL it asks on `/dev/tty` whether to install base CLI tools or development tooling. A non-interactive session defaults to base CLI tools and explains how to install development tooling later. The WSL route never calls Scoop, PowerShell, Flatpak, or desktop package installation.

The PowerShell installer remains guarded by `Windows_NT` and gains a message that it must be launched from native PowerShell, not WSL. Documentation provides distinct copy-paste commands for native Windows, WSL, and Linux.

## Verification

Shell tests will stub commands and environment variables to prove the three platform routes. A PowerShell static check will confirm that its native-Windows guard remains present. Chezmoi template rendering will confirm that each OS ignores incompatible scripts.
