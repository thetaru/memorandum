# WiFi
|項目|説明|
|:---|:---|
|デバイス名|wlp1s0|

## ■ systemd-networkdの設定
```sh
vim /etc/systemd/network/wlp1s0.network
```
```ini
[Match]
Name=wlp1s0
SSID=ABCD1234

[Network]
DHCP=yes
```

## ■ wpa_suppicantの設定
```sh
# SSIDを渡し、SSIDのパスフレーズを入力する
wpa_passphrase ABCD1234 | tee /etc/wpa_supplicant/wpa_supplicant-wlp1s0.conf
```
wpa_supplicantを起動する
```sh
# サービスの自動起動も有効にする
systemctl enable --now wpa_supplicant@wlp1s0
```

## ■ systemd-networkdの再起動
```sh
systemctl restart systemd-networkd.service
```
