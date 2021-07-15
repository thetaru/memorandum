# Bacukaサーバの構築
Web GUIを導入するため
## ■ インストール
### ● MySQLのインストール
```
```

### ● アクセスキーの取得

### ● Baculaのインストール

### ● [option] Baculumのインストール
BaculaのWeb GUIである`Baculum`をインストールします。
```
# cat < EOF > /etc/yum.repos.d/baculum.repo
[baculumrepo]
name=Baculum CentOS repository
baseurl=http://bacula.org/downloads/baculum/stable/centos
gpgcheck=1
enabled=1
EOF
```

## ■ バージョンの確認
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 事前準備系(特になければ消してok)

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
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 参考
https://straypenguin.winfield-net.com/
