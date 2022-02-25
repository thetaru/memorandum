# ローカルリポジトリ
インストールメディアからパッケージをインストールできるようにする。
```
mount /dev/sr0 /media
```
以下コマンドを実行すると、`/etc/apt/sources.list`が編集される。
```
apt-cdrom -m -d /media add
```
