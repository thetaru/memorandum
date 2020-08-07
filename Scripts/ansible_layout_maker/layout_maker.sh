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
mkdir -p playbook/group_vars/example

# host_vars: env
mkdir playbook/host_vars/192.168.0.1

# inventories:
mkdir playbook/inventory

# roles:
ansible-galaxy init playbook/roles

#######################################################################
# make yml files
#######################################################################

# Main Playbook
# Keep include module only
(
    echo "---"
    echo "#- include example_servers.yml"
) > playbook/site.yml

# Sub Playbook
(
    echo "---"
    echo "#- hosts:"
    echo "#  - example:"
    echo "#  roles:"
    echo "#    - common"
) > playbook/example_servers.yml

# inventory: ip and hostname
(
    echo "#[example]"
    echo "#192.168.0.1 node_hostname=example-host"
) > playbook/inventory/hosts

# group_vars:
# groups are separated by segments
# example-host group refer to group_vars/example/main.yml
(
    echo "---"
    echo "#ansible_ssh_user: root"
) > playbook/group_vars/all.yml

(
    echo "---"
    echo "#default_gateway: 192.168.0.254"
    echo "#ntp_server: ntp.nict.jp"
) > playbook/group_vars/example/main.yml

# host_vars: example-host refer to host_vars/192.168.0.1/main.yml
(
    echo "---"
    echo "# write about ..."
) > playbook/host_vars/192.168.0.1/main.yml
