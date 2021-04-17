#!/bin/bash

### CONST
zone=$(firewall-cmd --get-default-zone)

### INIT
## ports
list_ports=$(firewall-cmd --list-ports)
for port in ${list_ports[@]}; do
  firewall-cmd --permanent --zone=${zone} --remove-port=${port}
done

## rich rule
OLD_IFS=$IFS
IFS=$'\n'
list_rich_rules=$(firewall-cmd --list-rich-rules)
for rule in ${list_rich_rules[@]}; do
  firewall-cmd --permanent --zone=${zone} --remove-rich-rule="${rule}"
done
IFS=$OLF_IFS

## direct rule
OLD_IFS=$IFS
IFS=$'\n'
list_direct_rules=$(firewall-cmd --direct --get-all-rules)
for rule in ${list_direct_rules[@]}; do
  firewall-cmd --permanent --direct --remove-rule "${rule}"
done
IFS=$OLF_IFS

### reload
firewall-cmd --reload
