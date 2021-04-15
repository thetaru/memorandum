# isoイメージをdvdに焼く
dvd+rw-toolsをインストールします。
```
# pacman -S dvd+rw-tools
```
用途別のコマンドは以下のとおり
## ■ フルフォーマット
## ■ 上書きフォーマット
## ■ DVDに書き込み
```
# growisofs -dvd-compat -Z /dev/sr0=<isoイメージへのパス>
```
