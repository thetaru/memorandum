# Settings
windowsサーバとして、一般的な設定をPowershellで設定していく。  
以下、Powershellを管理者として実行しているものとする。
## ネットワーク接続
GUIを使って設定する方がよい。
## システムのプロパティ
### ■ コンピュータ名 - 変更
#### コンピュータ名
`-Restart`オプションを付けると再起動することに注意すること。
```ps1
> Rename-Computer -NewName <Hostname> -Force
```
#### ワークグループ名
```ps1
### ドメイン参加
> Add-Computer -DomainName <Domain> -Credential <DomainUser> -PassThru -Verbose
```

### ■ ハードウェア - デバイスのインストール設定
Windows Updateによるデバイスの自動インストールの設定を変更する。
|レジストリキー|HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching|
|:---|:---|
|レジストリ値名|SearchOrderConfig|
|レジストリ値||
|レジストリ値名|DriverUpdateWizardWuSearchEnabled|
|レジストリ値||

|レジストリキー|HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata|
|:---|:---|
|レジストリ値名|PreventDeviceMetadataFromNetwork|
|レジストリ値||

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
|レジストリキー|HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|
|:---|:---|
|レジストリ値名|PagingFiles|
|レジストリ値||

```ps1
### 設定値を確認する
> (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management').'PagingFiles'
```

|PagingFiles|説明|
|:---|:---|
|?:\pagefile.sys|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が有効|
|c:\pagefile.sys X Y|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`カスタム サイズ`が有効|
|c:\pagefile.sys 0 0|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`システム管理サイズ`が有効|
|(空)|`すべてのドライブのページング ファイルのサイズを自動的に管理する`が無効</br>`ページング ファイルなし`が有効|

```ps1
### カスタムサイズの設定
> Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -name 'PagingFiles' -value '<ページファイル保存先> <初期サイズ(MB)> <最大サイズ(MB)>' -type REG_MULTI_SZ
```
```ps1
### システム管理サイズの設定
>
```
```ps1
### ページングファイルなしの設定
>
```

### ■ リモート - リモートデスクトップ
|レジストリキー|HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server|
|:---|:---|
|レジストリ値名|fDenyTSConnections|
|レジストリ値|0(有効)</br>1(無効)|

```ps1
### 設定値を確認する
> (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server').'fDenyTSConnections'

### リモートデスクトップを有効に設定
> Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -name 'fDenyTSConnections' -value '0' -type DWord
```

## 機能と役割
GUIを使って設定する方がよい。

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
以下、不要なサービスを無効化する
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
以下、サービスのスタートアップの種類を変更する
### ■ XXX サービス
```ps1
> 
```
## イベントビューアー
## Windows Defender ファイアウォール
GUIを使って設定する方がよい。
## タスク スケジューラ
GUIを使って設定する方がよい。
## レジストリ
### ■ IPv6の無効化
### ■ 時刻同期の設定
ここでは、NTPクライアントとして上位NTPサーバを参照する設定のみ行う。  
そのため、NTPサーバとしての設定やポーリング間隔、アドバタイズなどの各種パラメータを調整する設定をしない。
|レジストリキー|HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters|
|:---|:---|
|レジストリ値名|NtpServer|
|レジストリ値|NTPサーバ(IPアドレス\|FQDN),オプション|

|オプション|同期方法|説明|
|:---|:---|:---|
|0x01|SpecialInterval||
|0x02|UseAsFallbackOnly||
|0x04|SymmetricActive||
|0x08|NTP request in Client mode||

```ps1
### 設定値を確認する
> (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters').'NtpServer'

### 同期先NTPサーバを設定
> Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters' -name 'NtpServer' -value 'ntp.nict.jp,0x8' 
```

https://www.server-world.info/query?os=Windows_Server_2019&p=ntp&f=2
### ■ リモートデスクトップ制限の解除
|レジストリキー|HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server|
|:---|:---|
|レジストリ値名|fSingleSessionPerUser|
|レジストリ値|1ユーザに対して複数セッションを許可する</br>1ユーザに対して1セッションを許可する|

※ 無課金の場合、制限を解除しても最大2セッションとなる
```ps1
### 設定値を確認する
> (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server').'fSingleSessionPerUser'

### 複数セッションを許す
> Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -name 'fSingleSessionPerUser' -value '0' -type DWord
```
### ■ 組織名/所有者名の設定
### ■ 自動メンテナンスの設定
自動メンテナンスはスケジュールされた時間にメンテナンスが実行される機能です。
## プロキシの設定
ieとwinhttp
## SNPの設定
## めも
UAC
