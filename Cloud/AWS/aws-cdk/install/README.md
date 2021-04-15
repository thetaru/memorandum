# インストール方法
Node.jsがインストールされていると仮定します。
```
# npm install -g aws-cdk
# pip install --upgrade aws-cdk.core
```
```
### version確認
# cdk --version
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
### AWSの認証情報とリージョンが設定されていることを確認
# cat ~/.aws/credentials
# cat ~/.aws/config
```
```
### AWS側の初期設定
# cdk bootstrap aws://<アカウントID>/<リージョン名>
```
