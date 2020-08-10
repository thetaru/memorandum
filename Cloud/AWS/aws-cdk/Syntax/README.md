# 前提条件
```
### aws-cliがインストール済みであること
# aws --version
```
```

### aws-cdkがインストール済みであること
# cdk --version
```
# Sample
## sample.py
```
from aws_cdk import (
    core,
    aws_ec2 as ec2,
)
import os
```
```
class Stack_Name(core.Stack):
```
```
    def __init__(self, scope: core.App, name: str, key_name: str, **kwargs) -> None:    # name: スタック名
        super().__init__(scope, name, **kwargs)
```
```
        ### VPCの定義
        vpc = ec2.Vpc(
            self, "VPC_NAME",                                                           # VPC名
            max_azs=1,                                                                  # avaialibility zone
            cidr="192.168.0.0/24",                                                      # VPC内のIPv4レンジ
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="public",                                                      # サブネット名
                    subnet_type=ec2.SubnetType.PUBLIC,                                  # サブネットの種類 [private|public]
                )
            ],
            nat_gateways=0,
        )
```
```
        ### セキュリティグループの定義
        sg = ec2.SecurityGroup(
            self, "Sg_Name",                                                            # SG名
            vpc=vpc,                                                                    # 対象のVPCを選択
            allow_all_outbound=True,
        )
        sg.add_ingress_rule(                                                            # 
            peer=ec2.Peer.any_ipv4(),
            connection=ec2.Port.tcp(22),
        )
```
```
        ### インスタンスの定義
        host = ec2.Instance(
            self, "Instance_Name",                                                      # インスタンス名
            instance_type=ec2.InstanceType("t2.micro"),                                 # インスタンスタイプの選択
            machine_image=ec2.MachineImage.latest_amazon_linux(),                       # マシンイメージの選択
            vpc=vpc,                                                                    # インスタンスが所属するVPCの選択
            vpc_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC), 
            security_group=sg,                                                          # 適用するセキュリティグループの選択
            key_name=key_name
        )
```
```
app = core.App()
Stack_Name(
    app, "Stack_Name",
    key_name=app.node.try_get_context("key_name"),
    env={
        "region": os.environ["CDK_DEFAULT_REGION"],
        "account":os.environ["CDK_DEFAULT_ACCOUNT"],
    }
app.synth()
```
## cdk.json
```
{
    "app": "python3 app.py"
}
```
## requirements.txt
バージョンは指定したほうがいい
```
aws-cdk.aws-ec2
```
# 実行方法
閉じた環境で実行したいので仮想環境を構築する
## 0. Python依存ライブラリのインストール
```
# python3 -m venv .env
```
```
# source .env/bin/activate
```
```
# pip install -r requirements.txt
```
```
### [option] AWSのシークレットキーをセット(既に設定済みなら飛ばしください)
# export AWS_ACCESS_KEY_ID=XXXXXX
# export AWS_SECRET_ACCESS_KEY=YYYYYY
# export AWS_DEFAULT_REGION=ap-northeast-1
```
## 1. SSH鍵の生成
```
### 鍵の生成
# export KEY_NAME=Key_Name
# aws ec2 create-key-pair --key-name ${KEY_NAME} --query 'KeyMaterial' --output text > ${KEY_NAME}.pem
```
```
# mv Key_Name.pem ~/.ssh/
# chmod 400 ~/.ssh/Key_Name.pem
```
## 2. デプロイ開始
```
# cdk deploy -c key_name="Key_Name"
```
## 3. SSHログイン
```
### IPアドレス確認
#  aws ec2 describe-instances --output=table --query 'Reservations[].Instances[].{InstanceId: InstanceId, PrivateIp: join(`, `, NetworkInterfaces[].PrivateIpAddress), GlobalIP: join(`, `, NetworkInterfaces[].Association.PublicIp), State: State.Name, Name: Tags[?Key==`Name`].Value|[0]}'
```
```
------------------------------------------------------------------------------------------------
|                                       DescribeInstances                                      |
+---------------+----------------------+---------------------------+---------------+-----------+
|   GlobalIP    |     InstanceId       |           Name            |   PrivateIp   |   State   |
+---------------+----------------------+---------------------------+---------------+-----------+
|  xx.xx.xxx.xxx|  yyyyyyyyyyyyyyyyyyy |  FirstEC2/First_Instance  |  192.168.0.93 |  running  |
+---------------+----------------------+---------------------------+---------------+-----------+
```
```
### 上で得たGlobalIPアドレスに対してSSH接続
# ssh -i ~/.ssh/Key_Name.pem ec2-user@xx.xx.xxx.xxx
```
```

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2018.03-release-notes/
5 package(s) needed for security, out of 6 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-192-168-0-93 ~]$
```
