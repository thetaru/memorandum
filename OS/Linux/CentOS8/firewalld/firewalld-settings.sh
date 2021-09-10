#!/bin/bash
set -eu

#
# ダイレクトルールは非対応
#

ZONE="public"

# Init
echo "- Initializing..."
## Ports
for port in $(firewall-cmd --list-ports); do
  firewall-cmd --remove-port="$port" --zone="$ZONE" --permanent
done

## Services
for service in $(firewall-cmd --list-services); do
  firewall-cmd --remove-service="$service" --zone="$ZONE" --permanent
done

## Sources
for source in $(firewall-cmd --list-sources); do
  firewall-cmd --remove-source="$source" --zone="$ZONE" --permanent
done

## Rich-Rules
OLDIFS=$IFS
IFS=$'\n'
for rule in $(firewall-cmd --list-rich-rules); do
  firewall-cmd --remove-rich-rule="$rule" --zone="$ZONE" --permanent
done
IFS=$OLDIFS

# Add Ports
echo "- Adding Ports..."
#firewall-cmd --add-port=22/tcp --zone="$ZONE" --permanent

# Add Services
echo "- Adding Services..."
#firewall-cmd --add-service=ssh --zone="$ZONE" --permanent

# Add Sources
echo "- Adding Sources..."
#firewall-cmd --add-source=192.168.137.0/24 --zone="$ZONE" --permanent

# Add Rich-Rules
echo "- Adding Rich Rules..."
firewall-cmd --add-rich-rule='rule family=ipv4 source address=192.168.137.0/24 port port=22 protocol=tcp accept' --zone="$ZONE" --permanent

# Reload
echo "- Reloading..."
firewall-cmd --reload

# Check Port/Service/RichRule
echo "+ Allowed Ports"
firewall-cmd --list-ports
echo "+ Allowed Services"
firewall-cmd --list-services
echo "+ Allowed Sources"
firewall-cmd --list-sources
echo "+ Allowed RichRules"
firewall-cmd --list-rich-rules

# End
echo "Done."
