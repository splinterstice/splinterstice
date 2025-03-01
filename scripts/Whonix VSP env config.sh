#!/bin/bash

set -e

# Ensure the script is run as root.
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Set up the correct Whonix repository.
echo "deb [arch=amd64] https://deb.whonix.org buster main" > /etc/apt/sources.list.d/whonix.list
wget -q -O - https://www.whonix.org/whonix.gpg | apt-key add -

# Update and upgrade the system.
apt-get update && apt-get -y upgrade

# Install general dependencies.
apt-get install -y build-essential curl wget git tar gzip openssl cmake software-properties-common

# Configure the Whonix-based VPS.
configure_whonix_vps() {
  echo "Setting up encrypted VPS with Whonix environment."
  apt-get install -y whonix-gateway whonix-workstation
  systemctl enable whonix-gateway
  systemctl start whonix-gateway
}

configure_whonix_vps

echo "Whonix VPS configuration completed successfully."