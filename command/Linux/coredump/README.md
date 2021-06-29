# コアダンプ出力
sleepコマンドを裏で動かしてからシグナル使ってセグフォで殺します。  
リストから殺したプロセスのPIDをひかえておきましょう。
```
# sleep 300&
# pkill -SIGSEGV sleep
# coredumpctl list
```
吐かれたダンプファイルを確認します。
```
# coredumpctl dump <PID>
```
