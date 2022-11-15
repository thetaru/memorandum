# journalctlでよくつかうやつ
## ■ 最近のメッセージを表示
```sh
journalctl -e
```

## ■ リアルタイムにログを表示
`tail -f`のような動作
```sh
journalctl -f
```

## ■ 特定サービスのログを表示
```sh
# ひとつ
journalctl -u <ユニット名>

# 複数
journalctl _SYSTEMD_UNIT=<ユニット名1> + _SYSTEMD_UNIT=<ユニット名2>
```

## ■ ログのプライオリティを指定して表示
```sh
journalctl -p <priority>
```
