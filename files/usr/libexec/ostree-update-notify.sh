#!/usr/bin/env bash

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/ostree-update-notify"
STATE_FILE="$STATE_DIR/notified-version"

mkdir -p "$STATE_DIR"

version=$(
    rpm-ostree status --json |
    jq -r '
        .deployments[]
        | select(.staged == true)
        | "\(.version)[\(."container-image-reference-digest" | sub("^sha256:"; "") | .[0:8])]"
    ' |
    head -n1
)

# No staged deployment
if [[ -z "$version" || "$version" == "null" ]]; then
    exit 0
fi

# Already notified
if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "$version" ]]; then
    exit 0
fi

notify-send \
    --app-name "Updater" \
    --icon=system-software-update \
    "System update available" \
    "Version $version is ready. Reboot to apply."

echo "$version" > "$STATE_FILE"