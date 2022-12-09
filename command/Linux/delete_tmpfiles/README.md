# 一時ファイルの削除
## ■ サービスが起動していることを確認
```sh
systemctl status systemd-tmpfiles-clean.service
```
## ■ 削除対象のファイルとディレクトリを確認
```sh
systemd-tmpfiles --cat-config
```

## ■ 対象のファイルとディレクトリを追加
`/etc/tmpfiles.d`配下に`*.conf`を作成することで追加できる。  
ファーマットは以下の通り。
