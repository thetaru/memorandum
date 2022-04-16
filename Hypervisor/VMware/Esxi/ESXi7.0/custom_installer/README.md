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
### ISOの作成
```ps1
> .\ESXi-Customizer-PS.ps1 -ozip -v70 -pkgDir <vibファイル>
> .\ESXi-Customizer-PS.ps1 -izip -v70 .\ESXi-7.0U1b-17168206-standard-customized.zip
```

## ■ Ref
- ["[WinError 10054] An existing connection was forcibly closed by the remote host" during "Exporting the Imageprofile"](https://github.com/VFrontDe/ESXi-Customizer-PS/issues/15)
