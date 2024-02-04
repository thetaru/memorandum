# Intel sound card snd_hda_intel not working
アップデートしたら、音が一切出ず、出力デバイスに"dummy output"しか表示されなくなった。
## サウンドカードが認識できているか確認
下記コマンドを実行すると、サウンド関連のデバイスが出力される。  
自分の環境では、一つもでなくなっていた。
```sh
aplay -l
```

## カーネルモジュールを読み込む
```sh
vi /etc/modprobe.d/disable_dmic.conf
```
```
options snd_hda_intel dmic_detect=0
```
設定したら、再起動する。
