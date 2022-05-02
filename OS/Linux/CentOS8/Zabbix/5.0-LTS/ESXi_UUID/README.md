# ESXiのUUID取得方法
マクロ`VMware.hv.hw.uuid`を手動設定する。  
ESXiにログインして、以下のコマンドを実行する。
```
esxcli system uuid get
```
