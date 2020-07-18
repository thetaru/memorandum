# Kdump
クラッシュ時にメモリ内容をファイルへ保存するサービス
## ■ 設定方法
### 1. サービスの確認
```
# systemctl status kdump.service
```
### 1.1 Kdumpを無効化していた場合
Kdumpを有効化します
```
# systemctl start kdump.service
```
### 2. [Option]カーネルパラメータの設定
Kdumpが有効になっていることを確認したら、カーネルダンプ出力に関する設定をします。  
```
# vi /etc/default/grub
```
```
GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=<UUID> rhgb quiet"
```
crashkernelの値はクラッシュ時に読み込まれるメモリ量(i.e. 保存されるメモリ量)です。  
デフォルトの値は```auto```になっていてクラッシュ時に欠損するメモリ内容分の大きさを自動で指定してくれます。  
```
GRUB_CMDLINE_LINUX="crashkernel=1024M resume=UUID=<UUID> rhgb quiet"
```
また、このように手動で設定することもできます。  
### 2.1 設定の反映
編集した```default```ファイルを使用して、GRUB2 設定を再生成します。
### 2.1.1 BIOSの場合
```
# grub2-mkconfig -o /boot/grub2/grub.cfg
```
### 2.1. UEFIの場合
```
# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```
上記コマンドよりブートローダーが再設定され、設定ファイルに指定したパラメーターが、次回の再起動後に適用されます。
