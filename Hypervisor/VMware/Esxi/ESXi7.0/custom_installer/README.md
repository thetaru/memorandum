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
# offline bundleを作成
> .\ESXi-Customizer-PS.ps1 -ozip -v70 -pkgDir <vibファイル>

# offline bundleからISOイメージを作成
> .\ESXi-Customizer-PS.ps1 -izip -v70 <offline bundle>
```

## ■ Ref
- ["[WinError 10054] An existing connection was forcibly closed by the remote host" during "Exporting the Imageprofile"](https://github.com/VFrontDe/ESXi-Customizer-PS/issues/15)
