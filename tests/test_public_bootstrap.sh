#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
for file in bootstrap/bootstrap-linux.sh bootstrap/bootstrap-windows.ps1; do
  test -f "$root/$file" || { echo "missing $file" >&2; exit 1; }
done
grep -Fq 'gh' "$root/bootstrap/bootstrap-linux.sh"
grep -Fq 'XDG_RUNTIME_DIR' "$root/bootstrap/bootstrap-linux.sh"
grep -Fq 'WSLg' "$root/bootstrap/bootstrap-linux.sh"
grep -Fq 'gh' "$root/bootstrap/bootstrap-windows.ps1"
grep -Fq 'vscode' "$root/bootstrap/bootstrap-windows.ps1"
grep -Fq 'emacs' "$root/bootstrap/bootstrap-windows.ps1"
echo 'Public bootstrap checks passed.'
