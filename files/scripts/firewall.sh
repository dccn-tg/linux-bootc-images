#!/usr/bin/env bash
set -euo pipefail

# firewall.sh — configure firewalld at image build time
# ---------------------------------------------------------------------------
# 1. Drop any inbound traffice to the public zone
# ---------------------------------------------------------------------------

if [[ "$(firewall-offline-cmd --get-default-zone)" != "public" ]]; then
    firewall-offline-cmd --set-default-zone=public
fi

firewall-offline-cmd --zone=public --set-target=DROP

# ---------------------------------------------------------------------------
# 2. Allow all traffic originating from localhost (loopback / 127.0.0.1 / ::1)
# ---------------------------------------------------------------------------
firewall-offline-cmd --zone=trusted --add-interface=lo
