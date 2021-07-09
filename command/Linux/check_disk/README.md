# ディスクがHDDかSSDか確認する
## ■ /sys/block/sdX/queue/rotational
|値|説明|
|:---|:---|
|0|デバイスsdXはHDD|
|1|デバイスsdXはSSD|

```
# cat /sys/block/sdX/queue/rotational
```

## ■ lshw
このコマンドでディスクの型番がとれます。
```
# lshw -c disk
```

## ■ hdparm
`which hdparm`でコマンドがなかったら次でインストールできます。  
hdparmは、HDDのパラメータの設定・確認するコマンドです。
```
# yum install hdparm
```
デバイスの情報を出してみます。
```
# hdparm -I /dev/sdX
```
※ SSDならここからtrimに対応しているか確認できます
