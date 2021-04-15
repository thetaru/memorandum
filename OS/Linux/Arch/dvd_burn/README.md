# isoイメージをdvdに焼く
dvd+rw-toolsをインストールします。
```
# pacman -S dvd+rw-tools
```
用途別のコマンドは以下のとおり
## ■ フルフォーマット
```
# dvd+rw-format -brank=full /dev/sr0
```
## ■ 上書きフォーマット
```
# dvd+rw-format -force /dev/sr0
```
## ■ DVDに書き込み
```
# growisofs -dvd-compat -Z /dev/sr0=<isoイメージへのパス>
```
