# I/Oトレース
## iostat
## blktrace
```sh
blktrace -d /dev/sda -o - | blkparse -i -
```
デバイス番号、CPU、シーケンス番号、タイムスタンプ、イベント名、リクエストタイプ、開始ブロック数、プロセス名
