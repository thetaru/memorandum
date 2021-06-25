# SELinux
## ■ 機能の概要
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|selinux-autorelabel-mark.service|なし||
|selinux-autorelabel.service|なし||

## ■ 主設定ファイル /etc/selinux/config
### ● パラメータ
#### SELINUX
|設定値|説明|
|:---|:---|
|enforcing|SELinuxの機能を有効にする|
|permissive|SELinuxの機能を有効にするが、ログのみ出力する(試験用)|
|disabled|SELinuxの機能を無効にする|

#### SELINUXTYPE
### ● 設定例
```
```
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 参考
