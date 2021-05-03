# Settings
なるべくPowershellで設定していきたい。
## ネットワーク接続
### ■ IPアドレス設定
```ps1
> 
```
### ■ DNSサーバ設定
```ps1
> 
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
Windows Updateによるデバイスの自動インストールの設定を変更します。
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
## サービス
## イベントビューアー
## Windows Defender ファイアウォール
