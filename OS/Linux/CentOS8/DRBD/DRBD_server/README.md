# DRBDサーバの構築
## ■ インストール
### elrepoレポジトリの登録
```
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
```
### DRBDパッケージのインストール
```
# yum search drbd
# yum install drbd90-utils kmod-drbd90
```
## ■ バージョンの確認
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||6996-7800/tcp||

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● yyyディレクティブ
- aaa(recommended)
- bbb
### ● zzzパラメータ
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ロギング
### ● rsyslog
### ● logrotate
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 設定の確認
## ■ 負荷テスト項目
## ■ 監視項目
