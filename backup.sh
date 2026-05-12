#!/usr/bin/env bash
set -euo pipefail

# Full mobile backup (directory-only)
# Edit REMOTES and LOCALS arrays as needed.

DATE="$(date +%Y-%m-%d)"       # captured once
BKP_DIR="$HOME/Phone/backups/$DATE"
TIMESTAMP="$(date +%H%M%S)"
LOG="$BKP_DIR/backup_${DATE}_${TIMESTAMP}.log"

REMOTES=(
  "/sdcard/DCIM/"
  "/sdcard/Download/"
  "/sdcard/Documents/"
  "/sdcard/Music/"
  "/sdcard/Pictures/"
  "/sdcard/Recordings/"
  "/sdcard/Movies/"
  "/sdcard/Audiobooks/"
  "/sdcard/Ringtones/"
  "/sdcard/Backups/"
  "/sdcard/Neobackup/"
)

LOCALS=(
  "$BKP_DIR/DCIM/"
  "$BKP_DIR/Download/"
  "$BKP_DIR/Documents/"
  "$BKP_DIR/Music/"
  "$BKP_DIR/Pictures/"
  "$BKP_DIR/Recordings/"
  "$BKP_DIR/Movies/"
  "$BKP_DIR/Audiobooks/"
  "$BKP_DIR/Ringtones/"
  "$BKP_DIR/Backups/"
  "$BKP_DIR/Neobackup/"
)

log() { printf '%s %s\n' "$(date -u +"%Y-%m-%d %H:%M:%SZ")" "$*"; }

# Check adb
if ! command -v adb &>/dev/null; then
  echo "adb not found in PATH" >&2
  exit 2
fi

# Ensure log directory exists, then log to file+stdout
mkdir -p "$(dirname "$LOG")"
exec > >(tee -a "$LOG") 2>&1

log "Backup started (source device -> $BKP_DIR)"

# Single device check
if ! adb get-state >/dev/null 2>&1; then
  log "Error: No device detected. Aborting."
  exit 3
fi

# Validate arrays
if [ "${#REMOTES[@]}" -ne "${#LOCALS[@]}" ]; then
  log "Error: REMOTES and LOCALS arrays length mismatch"
  exit 4
fi

# Pull once per directory.
for i in "${!REMOTES[@]}"; do
  remote="${REMOTES[i]}"
  local="${LOCALS[i]}"

  log "Processing: $remote -> $local"

  # Ensure parent exists, not the final dir (prevents /.../Audiobooks/Audiobooks)
  mkdir -p "$(dirname "${local%/}")"

  if adb pull "$remote" "$local"; then
    log "Pulled: $remote -> $local"
  else
    log "Warning: failed to pull $remote"
  fi
done

log "Backup finished"

