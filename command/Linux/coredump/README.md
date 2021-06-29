# コアダンプ出力
sleepコマンドを裏で動かしてからセグフォで殺します。
```
# sleep 300&
# pkill -SIGSEGV sleep
# coredumpctl list
```
吐かれたダンプファイルを確認します。
```
# coredumpctl dump <PID>
```
