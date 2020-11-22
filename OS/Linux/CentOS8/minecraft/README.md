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

### パッケージダウンロード先
# mkdir /opt/minecraft
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
[xx:yy:zz] [Server thread/INFO]: Done (x.x.x s)! For help, type "help"
<stopを入力して停止する>
```
### 所有権の変更
ここまでminecraftユーザで実行しているなら不要です。
```
# chown -R minecraft:minecraft /home/minecraft
```
### サービスとして登録する
```
# vi /etc/systemd/system/minecraft.service
```
```
[Unit]
Description=minecraft service

[Service]
Type=simple
CPUAccounting=yes
User=minecraft
Group=minecraft
WorkingDirectory=/home/minecraft
Environment=MAX_HEAP=1024
Environment=MIN_HEAP=1024
ExecStart=/usr/bin/java -Xmx${MAX_HEAP}M -Xms${MIN_HEAP}M -jar server.jar nogui
ExecStop=/usr/bin/java

Restart=always

[Install]
WantedBy=multi-user.target
```
```
### サービスの再読み込みと起動
# systemctl daemon-reload
# systemctl start minecraft.service
```
```
### サービスが正常に起動していることを確認する
# systemctl status minecraft.service
```
```
### サービスの自動起動有効化
# systemctl enable minecraft.service
```
