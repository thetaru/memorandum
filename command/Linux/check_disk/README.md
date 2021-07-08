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
