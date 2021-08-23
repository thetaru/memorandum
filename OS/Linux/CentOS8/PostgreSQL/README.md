# PostgreSQLサーバの構築
## ■ インストール
```
# yum install postgresql-server
```
## ■ バージョンの確認
```
# psql --version
```
```
psql (PostgreSQL) 10.17
```
## ■ 事前準備
postgresqlサーバのセットアップ(confファイルの生成など)を行います。
```
# /usr/bin/postgresql-setup --initdb
```
## ■ サービスの起動
```
# systemctl enable --now postgresql.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|postgresql.service|5432||

## ■ postgresql.conf
### ● XXXセクション
### ● 設定例

## ■ pg_hba.conf
### ● XXXセクション
### ● 設定例

## ■ セキュリティ
### ● firewall
### ● 認証
## ■ ロギング
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart postgresql.service
```
## ■ 設定の確認
### ● PostgreSQLへの接続(ログイン)
ログイン方法はpg_hba.confに沿ってするべきですが、例を示します。
```
# sudo -u postgres psql -U postgres
```
※ Ref: https://stackoverflow.com/questions/7695962/password-authentication-failed-for-user-postgres
