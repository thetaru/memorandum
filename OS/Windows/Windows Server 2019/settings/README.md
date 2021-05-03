# Settings
なるべくPowershellで設定していきたい。
## ネットワーク接続 
### ■ IPv6無効化
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
### ■ デバイスのインストール設定
|値|チェック|意味|
|:---|:---|:---|
|0|オフ|無効(Windows Updateによるデバイスドライバの自動インストールを行わない)|
|1|オン|有効(Windows Updateによるデバイスドライバの自動インストールを行う)|
|2|オン|有効(コンピュータ上にデイバイスドライバが見つからない場合、Windows Updateによるデバイスドライバの自動インストールを行う)|
```ps1
> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching').'SearchOrderConfig'
```
### ■ パフォーマンス - 詳細設定 - 仮想メモリ
### ■ リモート - リモートデスクトップ
