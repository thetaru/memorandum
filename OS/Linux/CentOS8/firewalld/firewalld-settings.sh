#!/bin/bash
set -eu

#
# リッチ・ダイレクトルールは非対応
#

ZONE="public"

# Init
echo "- Initializing..."
## Ports
for port in $(firewall-cmd --list-ports); do
  firewall-cmd --remove-port="$port" --zone="$ZONE" --permanent
done

for service in $(firewall-cmd --list-services); do
  firewall-cmd --remove-service="$service" --zone="$ZONE" --permanent
done

# Add Ports
echo "- Adding Ports..."
firewall-cmd --add-port=22/tcp --zone="$ZONE" --permanent
firewall-cmd --add-port=3401/udp --zone="$ZONE" --permanent
firewall-cmd --add-port=8081/tcp --zone="$ZONE" --permanent
firewall-cmd --add-port=10051/tcp --zone="$ZONE" --permanent

# Add Services
echo "- Adding Services..."
#firewall-cmd --add-service=ssh --zone="$ZONE" --permanent

# Reload
echo "- Reloading..."
firewall-cmd --reload

# Check Port/Service
echo "+ Allow Ports"
firewall-cmd --list-ports
echo
echo "+ Allow Services"
firewall-cmd --list-services

# End
echo "Done."
