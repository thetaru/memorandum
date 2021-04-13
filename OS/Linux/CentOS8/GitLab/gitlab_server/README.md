# Gitlabサーバの構築
## ■ prerequisite
|項目|設定値|
|:---|:---|
|OS|CentOS8|
|CPU|4|
|MEM|4|
|IPADDR|192.168.0.100|
|Storage|200GB|
|Software|Gitlab 13.5.4-ee|

## ■ Install
```
### Gitlabレポジトリの追加
# curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
```
`EXTERNAL_URL`をHTTPSにすると自動的にLet’s Encryptを使って証明書を発行しようとするのでHTTPに変更します。
```
### GitLabをインストール
# EXTERNAL_URL="http://192.168.0.100" yum install gitlab-ee
```
