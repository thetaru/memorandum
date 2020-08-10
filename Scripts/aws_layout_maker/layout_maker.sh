#!/bin/bash
# 2020/08/10
#######################################################################
# confirm
#######################################################################

echo "You are in '"`pwd`"' here."
read -p "Are you sure to make directories? (y/N): " confirm
case "$confirm" in
    [Yy]|[Yy][Ee][Ss])
        read -p "Input Project Name: " project
        if [[ -e ./$project ]]; then
            echo "${project} is already exists."
            exit
        fi
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

# make project directory
mkdir $project && cd $project

# initialize
cdk init --language python > /dev/null 2>&1

# virtual environment
source .env/bin/activate

# install packages and upgrade packages
pip install -r requirements.txt > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Bye"
    exit
fi

pip install --upgrade aws-cdk.core > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Bye"
    exit
fi

pip install --upgrade aws-cdk.aws_ec2 > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Bye"
    exit
fi

# make resource directory
mkdir ${project}/${project}_resources

#######################################################################
# make py files
#######################################################################

# target dir
Target=${project}/${project}_resources

# app.py
cat << EOS > app.py
from aws_cdk import (
    core,
    aws_ec2 as ec2,
)

import os

from ${project}.${project}_stack import ${project}Stack
app = core.App()
${project}Stack(
    app, "${project}",
    key_name=app.node.try_get_context("key_name"),
    env={
        "region": os.environ["CDK_DEFAULT_REGION"],
        "account": os.environ["CDK_DEFAULT_ACCOUNT"],
    }
)
app.synth()
EOS

# vpc
cat << EOS > $Target/vpc.py
from aws_cdk import (
    core,
    aws_ec2 as ec2
)

components = {
    "Vpc_Name1": {
        "cidr": "192.168.1.0/24",
        "subnet_conf": {
            "name": "public",
            "subnet_type": "PUBLIC",
        },
        "nat_gateways": 0
    },
    "Vpc_Name2": {
        "cidr": "192.168.2.0/24",
        "subnet_conf": {
            "name": "public",
            "subnet_type": "PUBLIC",
        },
        "nat_gateways": 0
    },
}
EOS

# security group
cat << EOS > $Target/security_group.py
from aws_cdk import (
    core,
    aws_ec2 as ec2
)

components = {
    "Sg_Name1": {
        "vpc": "Vpc_Name1",
        "allow_all_outbound": "True",
        "add_ingress_rule": {
            "peer": "Peer.any_ipv4()",
            "connection": "Port.tcp(22)",
        },
    },
    "Sg_Name2": {
        "vpc": "Vpc_Name2",
        "allow_all_outbound": "True",
        "add_ingress_rule": {
            "peer": "Peer.any_ipv4()",
            "connection": "Port.tcp(22)",
        },
    },
}
EOS

# instace
cat << EOS > $Target/instance.py
from aws_cdk import (
    core,
    aws_ec2 as ec2
)

components = {
    "Instance_Name1": {
        "instance_type": "t2.micro",
        "machine_image": "ec2.MachineImage.latest_amazon_linux()",
        "vpc": "Vpc_Name1",
        "vpc_subnets": {
            "subnet_type": "ec2.SubnetType.PUBLIC",
        },
        "security_group": "Sg_Name1",
        "key_name": "key_name",
    },
    "Instance_Name2": {
        "instance_type": "t2.micro",
        "machine_image": "ec2.MachineImage.latest_amazon_linux()",
        "vpc": "Vpc_Name2",
        "vpc_subnets": {
            "subnet_type": "ec2.SubnetType.PUBLIC",
        },
        "security_group": "Sg_Name2",
        "key_name": "key_name",
    },
}
EOS

# ${project}/${project}_stack.py
cat << EOS > ${project}/${project}_stack.py
from aws_cdk import (
    core,
    aws_ec2 as ec2
)
from ${project}_resources import (
    vpc,
    security_group,
    instance,
)
class ${project}Stack(core.Stack):
    def __init__(self, scope: core.Construct, name: str, key_name: str, **kwargs) -> None:
        super().__init__(scope, name, **kwargs)
        # The code that defines your stack goes here

        # Define VPC
        for vpc_name in vpc.components:
            vpc_conf = vpc.components[vpc_name]
            exec('''{} = ec2.Vpc(
                self, "{}",
                max_azs=1,
                cidr="{}",
                subnet_configuration=[
                    ec2.SubnetConfiguration(
                    name="{}",
                    subnet_type=ec2.SubnetType.{},
                )
            ],
                nat_gateways={}
            )'''.format(
                vpc_name,
                vpc_name,
                vpc_conf["cidr"],
                vpc_conf["subnet_conf"]["name"],
                vpc_conf["subnet_conf"]["subnet_type"],
                vpc_conf["nat_gateways"]))

        # Define SecurityGroup
        for sg_name in security_group.components:
            sg_conf = security_group.components[sg_name]
            exec('''{} = ec2.SecurityGroup(
                self, "{}",
                vpc={},
                allow_all_outbound={},
            )'''.format(
                sg_name,
                sg_name,
                sg_conf["vpc"],
                sg_conf["allow_all_outbound"]))

            exec('''{}.add_ingress_rule(
                peer=ec2.{},
                connection=ec2.{},
            )'''.format(
                sg_name,
                sg_conf["add_ingress_rule"]["peer"],
                sg_conf["add_ingress_rule"]["connection"]))

        # Define host
        for instance_name in instance.components:
            instance_conf = instance.components[instance_name]
            exec('''{} = ec2.Instance(
                self, "{}",
                instance_type=ec2.InstanceType("{}"),
                machine_image={},
                vpc={},
                vpc_subnets=ec2.SubnetSelection(subnet_type={}),
                security_group={},
                key_name={}
            )'''.format(
                instance_name,
                instance_name,
                instance_conf["instance_type"],
                instance_conf["machine_image"],
                instance_conf["vpc"],
                instance_conf["vpc_subnets"]["subnet_type"],
                instance_conf["security_group"],
                instance_conf["key_name"]))
EOS
