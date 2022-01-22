# NetworkManager
NetworkManagerを利用する方法に`CUI・TUI・GUI`がある。ただし、このページではCUI(nmcliコマンド)のみを扱う。
## ■ 機能の概要
NetworkManagerによって`/etc/sysconfig/`配下のファイル(e.g. `/etc/sysconfig/network-scripts/ifcfg-ens192`等)を管理する。  
もちろん、nmcliコマンドによる設定のみでなく、設定ファイルを手動で編集しNetworkManagerに読み込ませることもできる。

## ■ 関連サービス
|サービス名|ポート番号|
|:---|:---|
|NetworkManager.service|なし|

## ■ 主設定ファイル /etc/NetworkManager/NetworkManager.conf

## ■ 設定用コマンド
### 設定ファイルの読み込み
```
### コネクション名を確認
# nmcli connection show

### 編集した(コネクションと紐づく)設定ファイルを読み込み
# nmcli connection load /etc/sysconfig/network-scripts/ifcfg-<connection-name>

### コネクションに設定を反映
# nmcli connection up <connectoin-name>
```

## ■ 調査・確認用コマンド
