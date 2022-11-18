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
journalctl -u <ユニット名1> -u <ユニット名2>
```

## ■ ログのプライオリティを指定して表示
```sh
journalctl -p <priority>
```
