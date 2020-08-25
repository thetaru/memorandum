#!/bin/bash
read -p "Enter the IP address to join the cluster(e.g. 192.168.0.1): " node_ip
read -p "Enter the node username(e.g. kube-node): " node_name
ssh $node_name@$node_ip <<EOC
