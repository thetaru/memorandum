# ユーザ指定でコマンドを実行する
```sh
systemd-run --scope -q --uid=apache pstree -aug $$
```
