# マインクラフトサーバの構築
## ■ 前提条件
|項目|設定値|
|:---|:---|
|Hypervisor|vSphere 6.8|
|OS|CentOS8|
|CPU|4|
|MEM|4|
|Storage|200GB|
|Software|minecraft|
## ■ 事前準備
### ユーザ作成
```
### マインクラフト実行ユーザの作成
# useradd minecraft

### minecraftユーザのパスワード設定
# passwd minecraft
```
## ■ インストール
```
### javaのインストール
# yum install java
```
```
### パッケージのダウンロード
# curl -o /home/minecraft/Minecraft.tar.gz -O https://launcher.mojang.com/download/Minecraft.tar.gz
```
