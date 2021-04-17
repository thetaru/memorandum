#!/bin/bash

### INIT
list-ports=$(firewall-cmd --list-ports)
for port in ${list-ports[@]}; do
  firewall-cmd --remove-port=${port}
done
