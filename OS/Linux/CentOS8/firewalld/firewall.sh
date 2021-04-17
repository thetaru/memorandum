#!/bin/bash

### INIT
## ports
list_ports=$(firewall-cmd --list-ports)
for port in ${list_ports[@]}; do
  firewall-cmd --remove-port=${port}
done

## rich rule
OLD_IFS=$IFS
$IFS=$'\n'
list_rules=$(firewall-cmd --zone=public --list-rich-rules)
for rule in ${list_rules[@]}; do
  echo $rule
done
IFS=$OLF_IFS
