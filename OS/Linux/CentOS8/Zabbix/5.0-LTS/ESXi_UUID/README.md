# ESXiのUUID取得方法
ESXiにログインして、以下のコマンドを実行する。
```sh
# Uppercase
esxcfg-info -u

# Lowercase
esxcfg-info -u | awk '{print tolower($0)}'
```
※ ESXiサーバのマザーボードが持つUUID  
  
取得したUUIDは、監視対象ホストESXiのマクロ`{$VMWARE.HV.UUID}`と紐付ける。  
> **Note**  
> Zabbixのマクロは大文字小文字を区別することに注意する。  
> UUIDに大文字を含む場合、`Unknown hypervisor uuid`と出てデータ取得ができないため、  
> マクロに設定する際は、小文字に変換すること。
