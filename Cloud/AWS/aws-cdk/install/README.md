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
### AWSの認証情報とリージョンが設定されていることを確認
# cat ~/.aws/credentials
# cat ~/.aws/config
```
```
### AWS側の初期設定
# cdk bootstrap aws://<アカウントID>/<リージョン名>
```
