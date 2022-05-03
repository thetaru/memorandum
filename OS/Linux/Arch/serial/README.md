# シリアル通信
## ■ minicomのインストール
```
$ sudo pacman -S minicom
```

## ■ minicomの実行
ボーレートとデバイスを指定して実行する。
```
$ sudo LANG=C minicom -b 9600 -D /dev/ttyUSB0
```
