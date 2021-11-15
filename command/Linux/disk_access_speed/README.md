# ディスクのアクセス速度を測定する
`t`オプションがデバイス読み込み速度のベンチテストで`T`オプションがキャッシュ読み取り速度のベンチテストです。
```
hdparm -tT /dev/sdX
```
```
/dev/sdX:
 Timing cached reads:   17034 MB in  1.99 seconds = 8547.52 MB/sec
 Timing buffered disk reads: 3126 MB in  3.00 seconds = 1041.95 MB/sec
```
manによると、少なくとも2~3回実行する必要があるみたい。
