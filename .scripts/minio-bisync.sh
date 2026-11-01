
#!/usr/bin/env bash
set -Eeuo pipefail

LOCAL="$HOME/MinioSync"
REMOTE="minio:poco/MinioSync"
LOG="$HOME/.local/state/minio-bisync.log"
LOCK="$HOME/.cache/minio-bisync.lock"

mkdir -p "$LOCAL" "$(dirname "$LOG")" "$(dirname "$LOCK")"

# Prevent overlapping sync runs
exec 9>"$LOCK"
if ! flock -n 9; then
    echo "Sync already running; skipping."
    exit 0
fi

# Verify rclone is available
if ! /usr/bin/rclone listremotes | grep -qx 'minio:'; then
    echo "ERROR: rclone remote 'minio' not found." >&2
    exit 1
fi

echo "Starting sync: $(date)" | tee -a "$LOG"

if /usr/bin/rclone bisync "$LOCAL" "$REMOTE" \
    --log-file "$LOG" \
    --log-level INFO; then
    echo "Sync completed successfully."
else
    status=$?
    echo "Sync FAILED with exit code $status. Log: $LOG" >&2
    exit "$status"
fi

