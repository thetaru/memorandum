# コアダンプ出力
sleepコマンドを裏で動かしてからセグフォで殺します。  
リストからPIDを確認しておきましょう。
```
# sleep 300&
# pkill -SIGSEGV sleep
# coredumpctl list
```
吐かれたダンプファイルを確認します。
```
# coredumpctl dump <PID>
```
