# Jupyter Notebookサーバの構築
## ■ 事前準備
```
### サービス用ユーザの作成
# useradd -s /sbin/nologin -d /opt/jupyter jupyter

### 通常ログイン不可なのでbashを指定して実行
# su -s /bin/bash - jupyter -c "pip3 install -U pip --user"
```
## ■ インストール
```
# yum install python3-pip
```
## ■ バージョンの確認
```
### python
# python3 --version
```
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● yyyディレクティブ
- aaa(recommended)
- bbb
### ● zzzパラメータ
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
## ■ ロギング
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
