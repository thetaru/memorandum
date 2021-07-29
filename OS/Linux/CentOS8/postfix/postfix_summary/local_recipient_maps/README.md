# local_recipient_maps
## 任意のメールを受け付ける設定
```
local_recipient_maps =
luser_relay = catchall
```

## unknown user のバウンスメールの削除
```
local_recipient_maps =
luser_relay = unknown_user@localhost
```
```
unknown_user: /dev/null
```
```
# postalias /etc/aliases
```
