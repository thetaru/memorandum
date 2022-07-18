# あるパス配下にある各ディレクトリの使用容量を確認する
```sh
du -sh <パスを指定>/* --total
```

ディレクトリ`/home/thetaru/`配下のディレクトリ・ファイルの使用サイズを出力する。
```sh
du -sh /home/thetaru/* --total
```

`*`を付けない場合、ディレクトリ`/home/thetaru/`の使用サイズが出力される。
```sh
du -sh /home/thetaru/ 
```
