#!/usr/bin/env bash
set -euo pipefail

apply_seed() {
  local src="$1"
  if [ -d "$src" ]; then
    echo "[*] Applying seed from $src"
    # Copy the tree into / (permissions preserved where possible)
    cp -a "$src"/. /
  fi
}

# Apply either mode if present
apply_seed /seed/sysadmin
apply_seed /seed/ctf

exec "$@"
