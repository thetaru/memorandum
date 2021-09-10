#!/bin/bash
set -eu

#
# ダイレクトルールは非対応
# -> /etc/firewalld/direct.xmlに記述することを推奨します
#

ZONE="public"

# Init
echo "- Initializing..."
## Ports
for port in $(firewall-cmd --list-ports); do
  firewall-cmd --permanent --zone="$ZONE" --remove-port="$port"
done

## Services
for service in $(firewall-cmd --list-services); do
  firewall-cmd --permanent --zone="$ZONE" --remove-service="$service"
done

## Sources
for source in $(firewall-cmd --list-sources); do
  firewall-cmd --permanent --zone="$ZONE" --remove-source="$source"
done

## Rich-Rules
OLDIFS=$IFS
IFS=$'\n'
for rule in $(firewall-cmd --list-rich-rules); do
  firewall-cmd --permanent --zone="$ZONE" --remove-rich-rule="$rule"
done
IFS=$OLDIFS

# Add Ports
echo "- Adding Ports..."
#firewall-cmd --permanent --zone="$ZONE" --add-port=22/tcp

# Add Services
echo "- Adding Services..."
#firewall-cmd --permanent --zone="$ZONE" --add-service=ssh

# Add Sources
echo "- Adding Sources..."
#firewall-cmd --permanent --zone="$ZONE" --add-source=192.168.137.0/24

# Add Rich-Rules
echo "- Adding Rich Rules..."
firewall-cmd --permanent --zone="$ZONE" --add-rich-rule='rule family=ipv4 source address=192.168.137.0/24 port port=22 protocol=tcp accept'

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
