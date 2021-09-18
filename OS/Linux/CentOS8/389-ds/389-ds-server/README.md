## ■ インストール
```
### cockpit
# dnf install cockpit

### 389-ds
# dnf module list | grep 389
# dnf module enable 389-ds
# dnf install 389-ds-base
```
## ■ バージョンの確認
## ■ サービスの起動
```
### cockpit
# systemctl enable --now cockpit.socket

### 389-ds
#
```
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
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
## ■ 負荷テスト項目
## ■ 監視項目
## ■ Ref
- https://event.ospn.jp/osc2020-online-do/session/100667
