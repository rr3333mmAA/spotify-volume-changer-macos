#!/usr/bin/env bash

# Usage:
#   ./spotify-volume.sh --set 70
#   ./spotify-volume.sh --up 10
#   ./spotify-volume.sh --down 15

set -euo pipefail

STATE_FILE="${HOME}/.spotify_volume_last"

# Get current volume from Spotify
get_volume() {
  osascript -e "tell application \"Spotify\" to sound volume as integer"
}

# Set Spotify volume to a specific number
set_volume() {
  osascript -e "tell application \"Spotify\" to set sound volume to $1"
}

# Toggle mute
toggle_mute() {
  current=$(get_volume)
  if (( current == 0 )); then
    if [[ -f "$STATE_FILE" ]]; then
      previous=$(<"$STATE_FILE")
      set_volume "$previous"
      echo "Unmuted → $previous%"
    else
      set_volume 50  # fallback value
      echo "Unmuted → 50% (default)"
    fi
  else
    echo "$current" > "$STATE_FILE"
    set_volume 0
    echo "Muted"
  fi
}

# Parse arguments
case "${1:-}" in
  --get)
    get_volume
    ;;
  --set)
    set_volume "$2"
    ;;
  --up)
    current=$(get_volume)
    new=$(( current + $2 ))
    if (( new > 100 )); then new=100; fi
    set_volume "$new"
    ;;
  --down)
    current=$(get_volume)
    new=$(( current - $2 ))
    if (( new < 0 )); then new=0; fi
    set_volume "$new"
    ;;
  --toggle-mute)
    toggle_mute
    ;;
  *)
    echo "Usage:"
    echo "  $0 --get"
    echo "  $0 --set <0–100>"
    echo "  $0 --up <amount>"
    echo "  $0 --down <amount>"
    echo "  $0 --toggle-mute"
    exit 1
    ;;
esac
