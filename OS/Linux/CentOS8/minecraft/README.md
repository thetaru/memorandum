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
# useradd -s /bin/bash minecraft

### minecraftユーザのパスワード設定
# passwd minecraft

### パッケージダウンロード先
# mkdir /opt/minecraft/server
# chown minecraft:minecraft /opt/minecraft/server
```
## ■ インストール
### パッケージのインストール
```
### tmuxのインストール(これでminecraftサービスをコントロールします)
# yum install tmux

### javaのインストール
# yum install java
```
### サーバーファイルをダウンロード
```
# curl -o /opt/minecraft/server/server.jar -O https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
```
```
# ll /opt/minecraft/server
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
# vi /opt/minecraft/server/eula.txt
```
```
-  eula=false
+  eula=true
```
### server.jarを実行
```
# cd /opt/minecraft/server
```
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
# chown -R minecraft:minecraft /opt/minecraft/server
```
### サービスとして登録する
`MAX_HEAP`と`MIN_HEAP`の値は環境に応じて変更しましょう。
```
### Unitファイルの作成
# vi /etc/systemd/system/minecraft.service
```
```
[Unit]
Description=minecraft service
Wants=network-online.target
After=network-online.target

[Service]
Type=forking
CPUAccounting=yes
User=minecraft
Group=minecraft
ProtectSystem=full

WorkingDirectory=/opt/minecraft/server
Environment=MAX_HEAP=1024
Environment=MIN_HEAP=1024
ExecStart=tmux new-session -s minecraft -d "/usr/bin/java -Xmx${MAX_HEAP}M -Xms${MIN_HEAP}M -jar server.jar nogui"
ExecStop=tmux send-keys -t minecraft:0.0 '/say The Server is going down in 5 minutes!'
ExecStop=sleep 300
ExecStop=tmux send-keys -t minecraft:0.0 "save-all" C-m "/stop" C-m
ExecStop=sleep 3
ExecStop=pkill -f tmux

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
