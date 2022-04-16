# カスタムISOの作成
Windowsマシンで実施すること。
## ■ 事前準備
以下のファイルをダウンロードする。
- [vibファイル(Community Networking Driver for ESXi)](https://flings.vmware.com/community-networking-driver-for-esxi)
- [ESXi-Customizer-PS](https://github.com/VFrontDe/ESXi-Customizer-PS)

## ■ VMware PowerCLIのインストール
PowerShellを起動し、以下のコマンドを実行する。
```ps1
> Install-Module VMware.PowerCLI -Scope CurrentUser
```

## ■ カスタムISOの作成
PowerShellを起動し、以下のコマンドを実行する。
### SSL3を有効にする
```ps1
> [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Ssl3
```
適用後、再起動すること。
### ISOの作成
```ps1
> .\ESXi-Customizer-PS.ps1 -v<バージョン> -pkgdir <vibファイル>
```

## ■ Ref
- ["[WinError 10054] An existing connection was forcibly closed by the remote host" during "Exporting the Imageprofile"](https://github.com/VFrontDe/ESXi-Customizer-PS/issues/15)
