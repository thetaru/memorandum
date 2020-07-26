# コンテナの生成/起動
イメージからコンテナを作成し、コンテナ上で任意のプロセスを起動します。
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
#### pingコマンドの実行によりコンテナのバックグラウンド起動
```
# docker container run -d centos /bin/ping localhost
```
