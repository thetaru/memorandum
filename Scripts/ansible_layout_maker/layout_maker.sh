#!/bin/bash
#######################################################################
# confirm
#######################################################################

echo "You are in '"`pwd`"' here."
read -p "Are you sure to make directories? (y/N): " confirm
case "$confirm" in
    [Yy]|[Yy][Ee][Ss])
        echo "make directories..."
        ;;
    [Nn]|[Nn][Oo])
        echo "Bye"
        exit
        ;;
    *)
        echo "Invalid input. Please input y/N."
esac

#######################################################################
# make directories
#######################################################################

# root
mkdir playbook

# group_vars: env
mkdir playbook/group_vars

# host_vars: env
mkdir playbook/host_vars

# inventories:
mkdir playbook/inventory

# roles:
ansible-galaxy init playbook/roles

#######################################################################
# make yml files
#######################################################################

# Main Playbook
(
    echo "---"
) > playbook/site.yml

# inventory: ip and hostname
(
    echo "---"
    echo "#[example]"
    echo "#192.168.0.1 node_hostname=example-host"
) > playbook/inventory/hosts

# group_vars: example-host refer to group_vars/example/main.yml
(
    echo "---"
    echo "#write about ..."
    echo "#ntp_server=ntp.nict.jp"
) > playbook/group_vars/example/example.yml

# host_vars: example-host refer to host_vars/192.168.0.1/main.yml
(
    echo "---"
    echo "# write about ..."
) > playbook/host_vars/192.168.0.1/main.yml
