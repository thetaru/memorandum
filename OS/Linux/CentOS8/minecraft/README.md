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
### パッケージのインストール
```
### javaのインストール
# yum install java
```
### サーバーファイルをダウンロード
```
# curl -o /home/minecraft/server.jar -O https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
```
```
# ll /home/minecraft
```
```
-rw-r--r-- 1 root root      181 11月 23 03:06 eula.txt
drwxr-xr-x 2 root root       24 11月 23 03:06 logs
-rw-r--r-- 1 root root 37961464 11月 23 03:07 server.jar
-rw-r--r-- 1 root root     1084 11月 23 03:06 server.properties
```
### ライセンスに同意する
```
### End-User License Agreementに同意する
# vi /home/minecraft/eula.txt
```
```
-  eula=false
+  eula=true
```
### server.jarを実行
```
### サーバファイルを実行
# java -Xmx1024M -Xms1024M -jar server.jar nogui
```
```
...
[03:12:50] [Server thread/INFO]: Done (x.x.x s)! For help, type "help"
<stopを入力して停止する>
```
