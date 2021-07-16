# digdagサーバの構築
## ■ 事前準備
### ● ユーザ/グループ作成
```
# groupadd digdag
# useradd -M -g digdag -s /sbin/nologin digdag
```

## ■ インストール
### ● digdagのインストール
```
# curl -o /usr/local/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest"
# chmod +x /usr/local/bin/digdag
# echo 'export PATH="/usr/local/bin/digdag:$PATH"' >> ~/.bashrc
# source ~/.bashrc
```

### ● javaのインストール
```
# yum install java
```

### ● PostgreSQLのインストール
```
# yum install postgresql-server
# yum install postgresql-contrib
```

## ■ PostgreSQLの設定
```
# postgresql-setup  --initdb
```
```
# systemctl enable --now postgresql.service
# systemctl status postgresql.service
```
```
# 
```

## ■ バージョンの確認
```
# digdag --version
```
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 事前準備系(特になければ消してok)

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ロギング
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
