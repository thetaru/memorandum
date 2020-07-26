# コンテナの生成/起動
## Syntax
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--attach, -a|標準入力/標準出力/標準エラー出力にアタッチする|
|--cidfile|コンテナIDをファイルに出力する|
|--detach, -d|コンテナを作成し、バックグラウンドで実行する|
|--interactive, -i|コンテナの標準入力を開く|
|--name|コンテナの名前を指定する|
|--tty, -t|端末デバイスを使う|
### e.g.
#### echoコマンドを実行してHello Worldを出力
```
# docker container run -it --name "test1" centos /bin/echo "Hello World"
```
```
Hello World
```
#### bashの実行
```
# docker container run -it --name "test2" centos /bin/bash
```
# コンテナのバックグラウンド実行
## Syntax
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--detach, -d|バックグラウンド実行する|
|--user, -u|ユーザ名を指定|
|--restart=[no \| onfailure \| on-failure:回数n \| always \| unless-stopped]|コマンドの実行結果によって再起動を行う|
|--rm|コマンド実行完了時にコンテナを自動で削除|
### e.g.
#### pingコマンドの実行によりコンテナのバックグラウンド起動
```
# docker container run -d centos /bin/ping localhost
```
#### コンテナの常時再起動
コンテナ内で/bin/bashをexitコマンドで終了しても自動でコンテナを再起動します。
```
# docker container run -it --restart=always centos /bin/bash
```
```
[root@3878be285b91 /]# exit
exit
```
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         40 seconds ago      Up 35 seconds                           clever_wiles
```
