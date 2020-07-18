# NTP
## 設定方法
### 時刻同期時の挙動とその問題点
Windowsは```w32timeサービス```を使って同期をしています。  
このサービスのスタートアップの種類は、```手動(トリガー開始)```になっています。  
w32timeにおける```トリガー開始```というのは、  
```タスクスケジューラ/タスクスケジューラライブラリ/Microsoft/Windows/Time Synchronization```  
のタスクに設定されているトリガーを基準にサービス開始するというものです。
### §1. レジストリエディタから設定
```Win + R```から```regedit```でレジストリエディタを起動します。
```HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters```に移動し```NtpServer```の値を次のように変更します。
```
例えば、 ntp.nict.jp,0x8 や 192.168.0.1,0x8 など
```
### §1.1 コマンドから設定
やっていることはレジストリをいじっているだけです。  
cmdを***管理者権限***で起動します。  
環境ごとに読み替えて実行してください。
```
> reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters /v NtpServer /t "REG_SZ" /d "<NTPサーバIP or URL>,Param"
```
