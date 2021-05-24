# まずは解析の流れを体感してみよう
この章では、次の3点に注目して解析する。
- ファイルの作成/変更/削除を行う
- レジストリキーの作成/変更/削除
- ネットワーク通信

これらを監視した状態でプログラムを実行した際の動きをみる。  
そのために次の3つのツールを使用する。
- Stirling (バイナリエディタ)
- Process Monitor (ファイルとレジストリの監視)
- Wireshark (ネットワークの監視)

サンプルファイルは、以下からダウンロードできる。
```
https://github.com/kenjiaiko/binarybook
```

## ■ Process Monitorのログから挙動を確認する
今回は`chap01\sample_mal\Release\sample_mal.exe`を解析する。  
実行できない場合は、vcredist_x86.exeを[MS公式サイト](https://www.microsoft.com/en-us/download/details.aspx?id=26999)よりインストールすること。  
Process Monitorを実行した後、ログを確認する。  
