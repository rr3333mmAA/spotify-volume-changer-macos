#!/usr/bin/env bash

# Usage:
#   ./spotify-volume.sh --set 70
#   ./spotify-volume.sh --up 10
#   ./spotify-volume.sh --down 15

set -euo pipefail

# Get current volume from Spotify
get_volume() {
  osascript -e "tell application \"Spotify\" to sound volume as integer"
}

# Set Spotify volume to a specific number
set_volume() {
  osascript -e "tell application \"Spotify\" to set sound volume to $1"
}

# Parse arguments
case "$1" in
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
  --get)
    get_volume
    ;;
  *)
    echo "Usage:"
    echo "  $0 --get"
    echo "  $0 --set <0–100>"
    echo "  $0 --up <amount>"
    echo "  $0 --down <amount>"
    exit 1
    ;;
esac
