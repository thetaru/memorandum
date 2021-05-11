# Settings
なるべくPowershellで設定していきたい。  
以下、Powershellを管理者として実行しているものとする。
## ネットワーク接続
### ■ IPアドレス設定
|コマンドレット|説明|
|:---|:---|
|||

|オプション|説明|
|:---|:---|
|||

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
### ■ 不要なサービスの無効化
## イベントビューアー
## Windows Defender ファイアウォール
## レジストリ
### ■ IPv6の無効化
### ■ 時刻同期の設定
https://www.server-world.info/query?os=Windows_Server_2019&p=ntp&f=2
### ■ リモートデスクトップ制限の解除
## プロキシの設定
ieとwinhttp
