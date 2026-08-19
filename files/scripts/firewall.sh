#!/usr/bin/env bash
set -euo pipefail

# firewall.sh — configure firewalld at image build time
# ---------------------------------------------------------------------------
# 1. Drop any inbound traffice to the public zone
# ---------------------------------------------------------------------------

firewall-offline-cmd --set-default-zone=public
firewall-offline-cmd --zone=public --set-target=DROP
firewall-offline-cmd --zone=public --remove-services
firewall-offline-cmd --zone=public --remove-ports

# ---------------------------------------------------------------------------
# 2. Allow all traffic originating from localhost (loopback / 127.0.0.1 / ::1)
# ---------------------------------------------------------------------------
firewall-offline-cmd --zone=trusted --add-interface=lo
