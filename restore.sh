#!/usr/bin/env bash
set -euo pipefail

# Restore local backup directories to device (adb push)
# Edit DATE or BKP_DIR to point to the backup you want to restore.

DATE="${1:-$(date +%Y-%m-%d)}"         # pass date as first arg to restore a different day
BKP_DIR="$HOME/Phone/backups/$DATE"
TIMESTAMP="$(date +%H%M%S)"
LOG="$BKP_DIR/restore_${DATE}_${TIMESTAMP}.log"

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

log "Restore started (source: $BKP_DIR)"

# Device check (single)
if ! adb get-state >/dev/null 2>&1; then
  log "Error: No device detected. Aborting."
  exit 3
fi

# Validate arrays
if [ "${#REMOTES[@]}" -ne "${#LOCALS[@]}" ]; then
  log "Error: REMOTES and LOCALS arrays length mismatch"
  exit 4
fi

# Ensure source backup exists
if [ ! -d "$BKP_DIR" ]; then
  log "Error: backup directory does not exist: $BKP_DIR"
  exit 5
fi

# Push each local dir to remote (creates remote directory first)
for i in "${!REMOTES[@]}"; do
  remote="${REMOTES[i]}"
  local="${LOCALS[i]}"

  log "Processing: $local -> $remote"

  if [ ! -d "$local" ]; then
    log "Warning: source not found, skipping: $local"
    continue
  fi

  # Create remote directory (works on most Android shells)
  #if ! adb shell "mkdir -p \"${remote%/}\"" >/dev/null 2>&1; then
  #  log "Warning: failed to create remote dir: $remote (continuing)"
  #fi

  if adb push "$local" "$remote"; then
    log "Pushed: $local -> $remote"
  else
    log "Warning: failed to push: $local"
  fi
done

log "Restore finished"
