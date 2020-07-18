# NTP
## 設定方法
### §1. レジストリエディタから設定
```Win + R```から```regedit```でレジストリエディタを起動します。  
```HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters```に移動し```NtpServer```の値を変更します。  
例えば、 ```ntp.nict.jp,0x9``` や ```192.168.0.1,0x9``` などのように指定してください。
### §1.1 コマンドから設定
cmdを***管理者権限***で起動します。:warning:下記のコマンドをそのまま実行しないでください:warning:
```
> reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters /v NtpServer /t "REG_SZ" /d "[NTPサーバIP or URL],[Param]"
```
