# Sample
```
### class名がスタック名になります
class Stack_Name(core.Stack):
```
```
    def __init__(self, scope: core.App, name: str, key_name: str, **kwargs) -> None:
        super().__init__(scope, name, **kwargs)
```
```
        ### VPCの定義
        vpc = ec2.Vpc(
            self, "VPC_NAME",                                                       # VPC名
            max_azs=1,                                                              # avaialibility zone
            cidr="192.168.0.0/24",                                                  # VPC内のIPv4レンジ
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="public",                                                  # サブネット名
                    subnet_type=ec2.SubnetType.PUBLIC,                              # サブネットの種類 [private|public]
                )
            ],
            nat_gateways=0,
        )
```
```
        ### セキュリティグループの定義
        sg = ec2.SecurityGroup(
            self, "Sg_Name",                                                        # SG名
            vpc=vpc,                                                                # 対象のVPCを選択
            allow_all_outbound=True,
        )
        sg.add_ingress_rule(                                                        # 
            peer=ec2.Peer.any_ipv4(),
            connection=ec2.Port.tcp(22),
        )
```
```
        ### インスタンスの定義
        host = ec2.Instance(
            self, "Instance_Name",                                                   # インスタンス名
            instance_type=ec2.InstanceType("t2.micro"),                              # インスタンスタイプの選択
            machine_image=ec2.MachineImage.latest_amazon_linux(),                    # マシンイメージの選択
            vpc=vpc,                                                                 # インスタンスが所属するVPCの選択
            vpc_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC), 
            security_group=sg,                                                       # 適用するセキュリティグループの選択
            key_name=key_name
        )
```
