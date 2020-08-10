#!/bin/bash

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

# availability_zone
cat << 'EOS' > $Target/availability_zone.py
class AvailabilityZone:
    def __init__(self, region='ap-northeast-1') -> None:
        self.__region = region
        if self.__region == 'ap-northeast-1':
            self.__names = ['ap-northeast-1a', 'ap-northeast-1c', 'ap-northeast-1d']
        else:
            self.__names = []
    @property
    def names(self) -> list:
        return self.__names
    def name(self, az_number) -> str:
        return self.__names[az_number]
EOS
# nat_gateways
cat << 'EOS' > $Target/nat_gateway.py
import hashlib
from aws_cdk import (
    core,
    aws_ec2,
)
def create_nat_gateway(scope: core.Construct, vpc: aws_ec2.CfnVPC, subnet: aws_ec2.CfnSubnet) -> aws_ec2.CfnNatGateway:
    vpc_id = [tag['value'] for tag in vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
    subnet_id = [tag['value'] for tag in subnet.tags.render_tags() if tag['key'] == 'Name'].pop()
    id = hashlib.md5(subnet_id.encode()).hexdigest()
    eip = aws_ec2.CfnEIP(scope, f'{vpc_id}/EIP-{id}')
    nat_gateway = aws_ec2.CfnNatGateway(scope, f'{vpc_id}/NatGateway-{id}',
        allocation_id=eip.attr_allocation_id,
        subnet_id=subnet.ref,
        tags=[core.CfnTag(
            key='Name',
            value=f'{vpc_id}/NatGateway-{id}',
        )],
    )
    return nat_gateway
EOS

# route
cat << 'EOS' > $Target/route.py
import hashlib
from aws_cdk import (
    core,
    aws_ec2,
)
def create_privagte_route_table(scope: core.Construct, vpc: aws_ec2.CfnVPC, nat_gateway: aws_ec2.CfnNatGateway) -> aws_ec2.CfnRouteTable:
    vpc_id = [tag['value'] for tag in vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
    ngw_id = [tag['value'] for tag in nat_gateway.tags.render_tags() if tag['key'] == 'Name'].pop()
    id = hashlib.md5(ngw_id.encode()).hexdigest()
    route_table = aws_ec2.CfnRouteTable(scope, f'{vpc_id}/RouteTable-{id}',
        vpc_id=vpc.ref,
        tags=[core.CfnTag(
            key='Name',
            value=f'{vpc_id}/RouteTable-{id}',
        )],
    )
    aws_ec2.CfnRoute(scope, f'{vpc_id}/Route-{id}',
        route_table_id=route_table.ref,
        destination_cidr_block='0.0.0.0/0',
        nat_gateway_id=nat_gateway.ref,
    )
    return route_table
def create_public_route_table(scope: core.Construct, vpc: aws_ec2.CfnVPC, internet_gateway: aws_ec2.CfnInternetGateway) -> aws_ec2.CfnRouteTable:
    vpc_id = [tag['value'] for tag in vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
    igw_id = [tag['value'] for tag in internet_gateway.tags.render_tags() if tag['key'] == 'Name'].pop()
    id = hashlib.md5(igw_id.encode()).hexdigest()
    route_table = aws_ec2.CfnRouteTable(scope, f'{vpc_id}/RouteTable-{id}',
        vpc_id=vpc.ref,
        tags=[core.CfnTag(
            key='Name',
            value=f'{vpc_id}/RouteTable-{id}',
        )],
    )
    aws_ec2.CfnRoute(scope, f'{id}/Route-{id}',
        route_table_id=route_table.ref,
        destination_cidr_block='0.0.0.0/0',
        gateway_id=internet_gateway.ref,
    )
    return route_table
def create_route_table_association(scope: core.Construct, vpc: aws_ec2.CfnVPC, subnet: aws_ec2.CfnSubnet, route_table: aws_ec2.CfnRouteTable) -> aws_ec2.CfnSubnetRouteTableAssociation:
    vpc_id = [tag['value'] for tag in vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
    subnet_id = [tag['value'] for tag in subnet.tags.render_tags() if tag['key'] == 'Name'].pop()
    id = hashlib.md5(subnet_id.encode()).hexdigest()
    association = aws_ec2.CfnSubnetRouteTableAssociation(scope, f'{vpc_id}/SubnetRouteTableAssociation-{id}',
        route_table_id=route_table.ref,
        subnet_id=subnet.ref,
    )
    return association
EOS

# subnet
cat << EOS > $Target/subnet.py
import hashlib
import ipaddress
import uuid
from aws_cdk import (
    core,
    aws_ec2,
)
from ${project}_resources import (
    availability_zone,
    vpc,
)
class SubnetGroup:
    def __init__(self, scope: core.Construct, vpc: aws_ec2.CfnVPC, *,
            desired_layers: int=2,
            desired_azs: int=2,
            region: str='ap-northeast-1',
            private_enabled: bool=True,
            cidr_mask: int=20) -> None:
        self._cidr_mask = cidr_mask
        self._desired_azs = desired_azs
        self._desired_layers = desired_layers
        self._private_enabled = private_enabled
        self._region = region
        self._reserved_azs = 5
        self._reserved_layers = 3
        self._scope = scope
        self._vpc = vpc
        self._desired_subnet_points = []
        for layer_number in range(self._desired_layers):
            for az_number in range(self._desired_azs):
                self._desired_subnet_points.append([layer_number, az_number])
        self._public_subnets = []
        self._private_subnets = []
    @property
    def cidr_mask(self) -> int:
        return self._cidr_mask
    @property
    def desired_azs(self) -> int:
        return self._desired_azs
    @property
    def desired_layers(self) -> int:
        return self._desired_layers
    @property
    def desired_subnet_points(self) -> list:
        return self._desired_subnet_points
    @property
    def private_enabled(self) -> bool:
        return self._private_enabled
    @property
    def private_subnets(self) -> list:
        return self._private_subnets
    @property
    def public_subnets(self) -> list:
        return self._public_subnets
    @property
    def region(self) -> str:
        return self._region
    @property
    def reserved_azs(self) -> int:
        return self._reserved_azs
    @property
    def reserved_layers(self) -> int:
        return self._reserved_layers
    @property
    def scope(self) -> core.Construct:
        return self._scope
    @property
    def vpc(self) -> aws_ec2.CfnVPC:
        return self._vpc
    def create_subnets(self) -> None:
        nw = ipaddress.ip_network(self.vpc.cidr_block)
        cidrs = list(nw.subnets(new_prefix=self.cidr_mask))
        cidrs.reverse()
        az = availability_zone.AvailabilityZone()
        vpc_id = [tag['value'] for tag in self.vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
        for layer in range(self.reserved_layers):
            for az_number in range(self.reserved_azs):
                current = [layer, az_number]
                cidr = str(cidrs.pop())
                if current in self.desired_subnet_points:
                    id = hashlib.md5(f'{layer}-{az_number}'.encode()).hexdigest()
                    subnet = aws_ec2.CfnSubnet(self.scope, f'{vpc_id}/Subnet-{id}',
                        cidr_block=cidr,
                        vpc_id=self.vpc.ref,
                        availability_zone=az.name(az_number),
                        tags=[
                            core.CfnTag(
                                key='Name',
                                value=f'{vpc_id}/Subnet-{id}',
                            ),
                            core.CfnTag(
                                key='Layer',
                                value=f'{layer}',
                            ),
                            core.CfnTag(
                                key='AZNumber',
                                value=f'{az_number}',
                            ),
                        ],
                    )
                    if self.private_enabled and layer > 0:
                        self._private_subnets.append(subnet)
                    else:
                        self._public_subnets.append(subnet)
EOS

# vpc
cat << 'EOS' > $Target/vpc.py
from aws_cdk import (
    core,
    aws_ec2,
)
def create_vpc(scope: core.Construct, id: str, *,
        cidr='10.0.0.0/16',
        enable_dns_hostnames=True,
        enable_dns_support=True) -> aws_ec2.CfnVPC:
    vpc = aws_ec2.CfnVPC(scope, id,
        cidr_block=cidr,
        enable_dns_hostnames=enable_dns_hostnames,
        enable_dns_support=enable_dns_support,
        tags=[core.CfnTag(
            key='Name',
            value=id,
        )]
    )
    return vpc
def create_internet_gateway(scope: core.Construct, vpc: aws_ec2.CfnVPC) -> aws_ec2.CfnInternetGateway:
    vpc_id = [tag['value'] for tag in vpc.tags.render_tags() if tag['key'] == 'Name'].pop()
    internet_gateway = aws_ec2.CfnInternetGateway(scope, f'{vpc_id}/InternetGateway',
        tags=[core.CfnTag(
            key='Name',
            value=f'{vpc_id}/InternetGateway',
        )]
    )
    aws_ec2.CfnVPCGatewayAttachment(scope, f'{vpc_id}/VPCGatewayAttachment',
        vpc_id=vpc.ref,
        internet_gateway_id=internet_gateway.ref,
    )
    return internet_gateway
EOS

#
cat << EOS > ${project}/${project}_stack.py
from aws_cdk import core
from ${project}_resources import (
    vpc,
    subnet,
    nat_gateway,
    route,
)
class ${project}_Stack(core.Stack):
    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)
        # The code that defines your stack goes here
        vpc_id = 'MyVPC'
        subnet_desired_layers = 2
        subnet_desired_azs = 2
        private_subnet_enabled=True
        v = vpc.create_vpc(self, vpc_id)
        igw = vpc.create_internet_gateway(self, v)
        subnet_group = subnet.SubnetGroup(self, v,
            desired_layers=subnet_desired_layers,
            desired_azs=subnet_desired_azs,
            private_enabled=private_subnet_enabled)
        subnet_group.create_subnets()
        if subnet_group.public_subnets:
            public_route_table = route.create_public_route_table(self, v, igw)
            for public_subnet in subnet_group.public_subnets:
                route.create_route_table_association(self, v, public_subnet, public_route_table)
        if subnet_group.private_subnets:
            private_route_tables = []
            for public_subnet in subnet_group.public_subnets:
                ngw = nat_gateway.create_nat_gateway(self, v, public_subnet)
                private_route_table = route.create_privagte_route_table(self, v, ngw)
                private_route_tables.append(private_route_table)
            for private_subnet in subnet_group.private_subnets:
                az_number = [tag['value'] for tag in private_subnet.tags.render_tags() if tag['key'] == 'AZNumber'].pop()
                route.create_route_table_association(self, v, private_subnet, private_route_tables[int(az_number)])
EOS
