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

## ■ VMware PowerCLIのインポート
PowerShellを起動し、以下のコマンドを実行する。
```ps1
> Import-Module VMware.PowerCLI
```

## ■ カスタムISOの作成
### TLS1.2を有効にする
```ps1
> [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
> [Net.ServicePointManager]::SecurityProtocol
Tls12
```
### ISOの作成
```ps1
> .\ESXi-Customizer-PS.ps1 -v<バージョン> -pkgdir <vibファイル>
```
