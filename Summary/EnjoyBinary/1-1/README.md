# まずは解析の流れを体感してみよう
この章では、次の3点に注目して解析する。
- ファイルの作成/変更/削除を行う
- レジストリキーの作成/変更/削除
- ネットワーク通信

これらを監視した状態でプログラムを実行することで挙動を確認する。  
そのために次の3つのツールを使用する。
- Stirling (バイナリエディタ)
- Process Monitor (ファイルとレジストリの監視)
- Wireshark (ネットワークの監視)

サンプルファイルは、以下からダウンロードすること。
```
https://github.com/kenjiaiko/binarybook
```

## ■ Process Monitorのログから挙動を確認する
今回は`chap01\sample_mal\Release\sample_mal.exe`を解析する。  
Process Monitorを実行し、ログを確認する。  
