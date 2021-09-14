# Settings
なるべくPowershellで設定していきたい。  
以下、Powershellを管理者として実行しているものとする。
## ネットワーク接続
DHCPを用いず、静的にIPアドレスを割り当てることとする。
### ■ NICの情報を取得
設定するために必要となる情報を取得する。
```ps1 
> Get-NetAdapter | Select-Object InterfaceAlias,ifIndex
 
### 詳細情報
> Get-NetAdapter | Select-Object *
```
### ■ NIC名の変更
|コマンドレット|説明|
|:---|:---|
|Rename-NetAdapter|ネットワークアダプターの名前を変更する|

|オプション|説明|
|:---|:---|
|Name|現在のアダプター名|
|NewName|新しいアダプター名|

```ps1
> Rename-NetAdapter -Name <CurrentName> -NewName <NewName>
```

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

IPアドレスがすでに設定されている場合は、既存の設定を下記のコマンドで削除してから新しいIPアドレスを設定する。  
※ 明示的にデフォルトゲートウェイを削除しないと、デフォルトゲートウェイが残ることに注意する。
|コマンドレット|説明|
|:---|:---|
|Remove-NetIPAddress|IPアドレスの設定を削除する|

|オプション|説明|
|:---|:---|
|AddressFamily|IPアドレスのタイプ(IPv4\|IPv6)を指定する|
|DefaultGateway|デフォルトゲートウェイを指定する|
|InterfaceAlias|インターフェースのエイリアス名を指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|InterfaceIndex|インターフェイスのインデックスを指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|IPAddress|IPアドレスを指定する|

```ps1
> Remove-NetIPAddress -InterfaceAlias <Interface> -IPAddress <IPaddr> -AddressFamily "IPv4" -DefaultGateway <Gateway>
```

### ■ DNSサーバ設定
|コマンドレット|説明|
|:---|:---|
|Set-DnsClientServerAddress|DNSサーバを設定する|

|オプション|説明|
|:---|:---|
|InterfaceAlias|インターフェースのエイリアス名を指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|InterfaceIndex|インターフェイスのインデックスを指定する</br>Get-NetIPAddressコマンドレットなどで確認できる|
|ServerAddress|DNSサーバを指定する|
|ResetServerAddresses|DNSサーバのIPアドレスをクリアする|

```ps1
> Set-DnsClientServerAddress -InterfaceAlias <Interface> -ServerAddress <IPaddr>
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
### 設定値を確認する
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
|キー|HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|
|:---|:---|
|値|PagingFiles|

```ps1
### 設定値を確認する
> (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management').'PagingFiles'
```

|PagingFiles|説明|
|:---|:---|
|?:\pagefile.sys|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が有効|
|c:\pagefile.sys 0 0|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`システム管理サイズ`が有効|
|c:\pagefile.sys X Y|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`カスタムサイズ`が有効|
|(空)|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`ページング ファイルなし`が有効|

```ps1
> Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -name 'PagingFiles' -value '<ページファイル保存先> <初期サイズ(MB)> <最大サイズ(MB)>' -type REG_MULTI_SZ
```

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
### ■ ActiveX Installer (AxInstSV)
```ps1
> Stop-Service -Name 'AxInstSV'
> Set-Service 'AxInstSV' -StartupType Disabled
```
### ■ Bluetooth オーディオ ゲートウェイ サービス
```ps1
> Stop-Service -Name 'BTAGService'
> Set-Service 'BTAGService' -StartupType Disabled
```
### ■ Bluetooth サポート サービス
```ps1
> Stop-Service -Name 'bthserv'
> Set-Service 'bthserv' -StartupType Disabled
```
## イベントビューアー
## Windows Defender ファイアウォール
## レジストリ
### ■ IPv6の無効化
### ■ 時刻同期の設定
|オプション|同期方法|説明|
|:---|:---|:---|
|0x01|SpecialInterval||
|0x02|UseAsFallbackOnly||
|0x04|SymmetricActive||
|0x08|NTP request in Client mode||

https://www.server-world.info/query?os=Windows_Server_2019&p=ntp&f=2
### ■ リモートデスクトップ制限の解除
### ■ 組織名/所有者名の設定
## プロキシの設定
ieとwinhttp
