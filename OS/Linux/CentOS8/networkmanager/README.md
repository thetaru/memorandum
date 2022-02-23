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
### コネクションの作成/削除
ネットワークインターフェース(NIC)と論理インターフェース(コネクション)を紐づけの操作を行う。  
ユーザは直接デバイスをさわることなく設定することができる。
```
### コネクションの作成
# nmcli connection add con-name <connection-name> ifname <device-name> type ethernet

### コネクションの削除
# nmcli connection delete <connection-name>
```
### コネクションの起動/停止
```
### コネクションの起動(設定の反映も兼ねる)
# nmcli connection up <connection-name>

### コネクションの停止
# nmcli connection down <connection-name>
```
### コネクションの設定
#### コマンドによる設定
はじめに、一般的な設定項目を紹介する。
|パラメータ|設定値|意味|
|:---|:---|:---|
|connection.autoconnect|||
|ipv4.method|||
|ipv4.addresses|||
|ipv4.gateway|||
|ipv4.dns|||
|ipv4.routes|||
|ipv4.may-fail|||
|ipv4.never-default|||
|ipv6.method|disable||

#### コンフィグによる設定
設定ファイルを手動で編集した場合は以下のように設定する。  
※ CentOS9から`/etc/sysconfig/network-scripts/`はdeprecatedであることに注意
```
### コネクション名を確認
# nmcli connection show

### (コネクションと紐づくネットワークインターフェースの)設定ファイルを読み込み
# nmcli connection load /etc/sysconfig/network-scripts/ifcfg-<device-name>

### コネクションに設定を反映
# nmcli connection up <connection-name>
```

## ■ 調査・確認用コマンド
### コネクションのバックアップを作成
```
# nmcli connection clone <connection-name> <backup-connection-name>
```
