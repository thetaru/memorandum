# Settings
なるべくPowershellで設定していきたい。  
以下、Powershellを管理者として実行しているものとする。
## ネットワーク接続
### ■ NICの情報を取得
設定するために必要となる情報を取得する。
```ps1
> Get-NetAdapter
```
### ■ NIC名の変更
### ■ IPアドレス設定
|コマンドレット|説明|
|:---|:---|
|New-NetIPAddress|IPアドレスの設定を新規に作成する|

|オプション|説明|
|:---|:---|
|AddressFamily|IPアドレスのタイプ(IPv4\|IPv6)を指定する|
|DefaultGateway|デフォルトゲートウェイを指定する|
|InterfaceAlias|インターフェースのエイリアス名を指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|InterfaceIndex|インターフェイスのインデックスを指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|IPAddress|IPアドレスを指定する|
|PrefixLength|サブネットマスクのビット数を指定する|

```ps1
> New-NetIPAddress -InterfaceAlias <Interface> -IPAddress <IPaddr> -PrefixLength <Prefix> -AddressFamily "IPv4" -DefaultGateway <Gateway>
```

IPアドレスがすでに設定されている場合は、既存の設定を下記のコマンドで削除してください。
|コマンドレット|説明|
|:---|:---|
|Remove-NetIPAddress|IPアドレスの設定を削除する|

|オプション|説明|
|:---|:---|
|AddressFamily|IPアドレスのタイプ(IPv4\|IPv6)を指定する|
|IPAddress|IPアドレスを指定する|

```ps1
> Remove-NetIPAddress -IPAddress <IPaddr> -AddressFamily "IPv4" -Confirm
> New-NetIPAddress -InterfaceAlias <Interface> -IPAddress <IPaddr> -PrefixLength <Prefix> -AddressFamily "IPv4" -DefaultGateway <Gateway>
```

### ■ DNSサーバ設定
```ps1
```
### ■ IPv6無効化
```ps1
> Disable-NetAdapterBinding -Name <NetworkAdapter> -ComponentID ms_tcpip6
```
## システムのプロパティ
### ■ コンピュータ名 - 変更
#### コンピュータ名
`-Restart`オプションを付けると再起動することに注意すること。
```ps1
> Rename-Computer -NewName <Hostname> -Force
```
#### ワークグループ名
```ps1
> 
```
### ■ ハードウェア - デバイスのインストール設定
Windows Updateによるデバイスの自動インストールの設定を変更する。
|キー|HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching|
|:---|:---|
|値|SearchOrderConfig|
|値|DriverUpdateWizardWuSearchEnabled|

|キー|HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata|
|:---|:---|
|値|PreventDeviceMetadataFromNetwork|

```ps1
### デフォルトの設定値を確認する
> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching').'SearchOrderConfig'
> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching').'DriverUpdateWizardWuSearchEnabled'
> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata').'PreventDeviceMetadataFromNetwork'
```
```ps1
### 「いいえ」に設定する
> Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -name 'SearchOrderConfig' -value '0' -type DWord
> Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -name 'DriverUpdateWizardWuSearchEnabled' -value '0' -type DWord
> Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata' -name 'PreventDeviceMetadataFromNetwork' -value '1' -type DWord
```
### ■ 詳細設定 - パフォーマンス - 設定 - 詳細設定 - 仮想メモリ - 変更
### ■ リモート - リモートデスクトップ
## 機能と役割
### ■ SNMPクライアント
## Windowsの設定
### ■ システム
### ■ デバイス
### ■ プライバシー
## コントロールパネル
### ■ ユーザー アカウント
### ■ 電源オプション
### ■ 自動再生
## フォルダー オプション
## ローカル セキュリティ ポリシー
## サービス
不要なサービスを無効化する。
### ■ Bluetooth
## イベントビューアー
## Windows Defender ファイアウォール
## レジストリ
### ■ IPv6の無効化
### ■ 時刻同期の設定
https://www.server-world.info/query?os=Windows_Server_2019&p=ntp&f=2
### ■ リモートデスクトップ制限の解除
## プロキシの設定
ieとwinhttp
