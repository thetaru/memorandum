# AWS CLI
## ■ Install
```
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# ./aws/install
```
```
### version確認
# aws --version
```
```
### クレデンシャルの設定
# aws configure
AWS Access Key ID [None]: XXXX
AWS Secret Access Key [None]: XXXX
Default region name [None]: ap-northeast-1
Default output format [None]: json
```
```
### 設定が入っていることを確認
# cat ~/.aws/credentials
```
```
[default]
aws_access_key_id = XXXXXXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYYYYYY
```
## ■ Ref
https://docs.aws.amazon.com/cli/latest/reference/
