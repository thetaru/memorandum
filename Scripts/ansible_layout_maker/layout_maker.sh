#!/bin/bash
# https://thinkit.co.jp/article/9871
# is ansible installed ?



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
# groups are separated by segments
# directories in group_vars are named by <IP-ADDR>_<PREFIX>
mkdir -p playbook/group_vars/192.168.0.0_24

# host_vars: env
mkdir -p playbook/host_vars/192.168.0.1

# inventories:
mkdir playbook/inventory

# roles:
ansible-galaxy init playbook/roles/common

#######################################################################
# make yml files
#######################################################################

# inventory: ip and hostname
(
    echo "#[example]"
    echo "#192.168.0.1 node_hostname=example-host"
) > playbook/inventory/hosts

# Main Playbook
# Keep include module only
(
    echo "---"
    echo "#- import-playbook: example_servers.yml"
) > playbook/site.yml

# Sub Playbook
(
    echo "---"
    echo "#- name: deploy"
    echo "#  hosts:"
    echo "#    - example"
    echo "#  become: yes"
    echo "#  roles:"
    echo "#    - common"
) > playbook/example_servers.yml

# group_vars:
# example-host group refer to group_vars/example/main.yml
(
    echo "---"
    echo "#ansible_ssh_user: root"
) > playbook/group_vars/all.yml

(
    echo "---"
    echo "#default_gateway: 192.168.0.254"
    echo "#ntp_server: ntp.nict.jp"
) > playbook/group_vars/192.168.0.0_24/main.yml

# host_vars: example-host refer to host_vars/192.168.0.1/main.yml
(
    echo "---"
) > playbook/host_vars/192.168.0.1/main.yml

# roles:
(
    echo "---"
    echo "#- name: example task"
    echo "#  hostname:"
    echo "#    name: "{{ node_hostname }}"
) > playbook/roles/common/main.yml
