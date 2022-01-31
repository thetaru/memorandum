# NetworkManager
NetworkManagerを利用する方法に`CUI・TUI・GUI`がある。ただし、このページでは`CUI`(nmcliコマンド)のみを扱う。
## ■ 機能の概要
NetworkManagerによって`/etc/sysconfig/`配下のファイル(e.g. `/etc/sysconfig/network-scripts/ifcfg-ens192`等)を管理する。  
また、nmcliコマンドによる設定のみでなく、設定ファイルを手動で編集しNetworkManagerに読み込ませることもできる。

## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|NetworkManager.service|なし|ネットワーク設定の管理|

## ■ 主設定ファイル /etc/NetworkManager/NetworkManager.conf

## ■ 設定用コマンド
### コマンドによる設定
一般的な設定項目を紹介する。
|パラメータ|設定値|意味|
|:---|:---|:---|
|ipv4.method|||
|ipv4.addresses|||
|ipv4.gateway|||
|ipv4.dns|||
|ipv4.routes|||
||||

### コンフィグによる設定
設定ファイルを手動で編集した場合は以下のように設定する。  
※ CentOS9から`/etc/sysconfig/network-scripts/`はdeprecatedであることに注意
```
### コネクション名を確認
# nmcli connection show

### 編集した(コネクションと紐づく)設定ファイルを読み込み
# nmcli connection load /etc/sysconfig/network-scripts/ifcfg-<connection-name>

### コネクションに設定を反映
# nmcli connection up <connection-name>
```

## ■ 調査・確認用コマンド
