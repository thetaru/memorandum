#!/bin/bash
read -p "Enter the IP address to join the cluster(e.g. 192.168.0.1): " node_ip

# Get Token
token=`kubeadm token list | awk '{ print $1 }'`

# If empty
if [[ $token -eq "" ]]; then
  kubeadm token create
  token=`kubeadm token list | awk '{ print $1 }'`
fi

ssh root@$node_ip <<EOC
  kubeadm join 
