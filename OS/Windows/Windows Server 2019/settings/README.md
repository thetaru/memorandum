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
Windows Updateによるデバイスの自動インストールの設定を変更します。
|キー|HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata|
|:---|:---|
|値|SearchOrderConfig|

|値|チェック|意味|
|:---|:---|:---|
|0|オフ|無効</br>Windows Updateによるデバイスドライバの自動インストールを行わない|
|1|オン|有効</br>Windows Updateによるデバイスドライバの自動インストールを行う|
|2|オン|有効</br>コンピュータ上にデイバイスドライバが見つからない場合、Windows Updateによるデバイスドライバの自動インストールを行う|
```ps1
### デフォルトの設定値を確認する
> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching').'SearchOrderConfig'
```
```ps1
### オフに設定する
> Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -name 'SearchOrderConfig' -value '0'
```
### ■ パフォーマンス - 詳細設定 - 仮想メモリ
### ■ リモート - リモートデスクトップ
