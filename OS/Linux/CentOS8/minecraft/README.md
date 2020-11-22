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
# curl -o /home/minecraft/server.jar -O https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
```
```
### サーバファイルを実行
# java -Xmx1024M -Xms1024M -jar server.jar nogui
```
