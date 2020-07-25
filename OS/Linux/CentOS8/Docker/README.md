# Docker
## § INSTALL
[公式](https://docs.docker.com/engine/install/centos/)を参照してください。  
バージョンや依存関係でインストールできない場合は[ここ](https://download.docker.com/linux/)からパッケージを探します。
```
# yum -y install https://download.docker.com/linux/<path_to_rpm>
```

## § COMMAND
## § バージョン確認(docker version)
### docker version コマンド
```
# docker version
```
## § 実行環境確認(docker system info)
### docker system info コマンド
```
# docker system info
```
## § ディスク使用率状況
### docker system df コマンド
Dockerが使用しているディスクの使用状況を表示します。  
```-v```を付けると詳細表示になります。
```
# docker system df [-v]
```
#### e.g.
```
# docker system df
```
```
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              2                   2                   206.3MB             0B (0%)
Containers          2                   1                   1.116kB             0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
```
## § イメージのダウンロード(docker image pull)
### docker image pull コマンド
イメージのダウンロードをします。
```
# docker image pull [option] docker-iamge[:tag]
```
#### e.g.
```
# docker image pull ubuntu:latest
```
## § イメージの情報取得(docker image ls/inspect)
### docker image ls コマンド
取得したイメージの一覧表示をします。
```
# docker image ls [option] [repository]
```
|オプション|意味|
|:---|:---|
|-all, -a|すべてのイメージを表示|
|--digests|ダイジェストを表示するかどうか|
|--no-trunc|結果をすべて表示する|
|--quiet, -q|DockerイメージIDのみ表示|
#### e.g.
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1e4467b07108        20 hours ago        73.9MB
```
### docker image inspect コマンド
イメージの詳細情報を表示します。  
出力はJSON形式です。
```
# docker image inspect [option] docker-image[:tag]
```
#### e.g.
```
# docker image inspect --format="{{ .Os}}" ubuntu:latest
```
```
linux
```
## § イメージのタグ設定(docker image tag)
### docker image tag コマンド
Dockerイメージにタグを付けます。
```
# docker image tag SOURCE-image[:tag] TARGET-image[:tag]
```
#### e.g.
タグを変更します。
```
# docker image tag ubuntu:latest hoge:1.0
```
タグが変更されていることを確認します。
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hoge                1.0                 1e4467b07108        20 hours ago        73.9MB
ubuntu              latest              1e4467b07108        20 hours ago
```
hogeとubuntuのIMAGE IDが同じなので実体は同一です。(ハードリンクみたいなイメージ)
## § イメージの検索(docker search)
### docker search コマンド
Docker Hubに公開されているDockerイメージを検索します。
```
# docker search [option] 検索キーワード
```
|オプション|意味|
|:---|:---|
|--no-trunc|結果をすべて表示する|
|--limit|n件の検索結果を表示する|
|--filter=stars=n|お気に入りの数(n以上)の指定|
#### e.g.
```
# docker search nginx
```
```
NAME                               DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
nginx                              Official build of Nginx.                        13509               [OK]
...
```
## § イメージの削除(docker image rm)
### docker image rm コマンド
作成したイメージを削除します。
```
# docker image rm [option] docker-image1 [docker-image2]
```
|オプション|意味|
|:---|:---|
|--force, -f|イメージを強制的に削除する|
|--no-prun|中間イメージを削除しない|
#### e.g.
```
# docker image rm ubuntu -f
```
```
Untagged: ubuntu:latest
Deleted: ubuntu@sha256:123456789123456789123456789123456789
```
### docker image prune コマンド
未使用のDockerイメージを削除します。
```
# docker image prune [option]
```
|オプション|意味|
|:---|:---|
|--all, -a|使用していあないイメージをすべて削除する|
|--force, -f|イメージを強制的に削除する|
## § Docker Hubからのログイン/ログアウト(docker login/logout)
### docker login コマンド
Docker Hubにログインします。
```
# docker login [option] [サーバ名]
```
|オプション|意味|
|:---|:---|
|--password, -p|パスワード|
|--username, -u|ユーザ名|
#### e.g.
```
# docker login
USERNAME: 登録したユーザ名
PASSWORD: 登録したパスワード
Login Succeeded
```
### docker logout コマンド
Docker Hubからログアウトします。
```
# docker logout [サーバ名]
```
#### e.g.
```
# docker logout
```
```
Removing login credentials for https://index.docker.io/v1/
```
## § イメージのアップロード(docker image push)
### docker image コマンド
Docker Hubにイメージをアップロードします。
```
# docker image push docker-image[:tag]
```
## § コンテナの生成/起動(docker container run)
### docker container run コマンド
Dockerイメージからコンテナ上で任意のプロセスを起動します。
```
# docker container run [option] docker-image[:tag] [argument]
```
`tag`を指定しないとデフォルトでは`latest`になります。
|オプション|意味|
|:---|:---|
|--attach, -a|標準入力/標準出力/標準エラー出力にアタッチする|
|--cidfile|コンテナIDをファイルに出力する|
|--detach, -d|コンテナを作成し、バックグラウンドで実行する|
|--interactive, -i|コンテナの標準入力を開く|
|--name||
|--port, -p||
|--tty, -t|端末デバイスを使う|
#### e.g.
test1というコンテナを作成してその中で/bin/calを実行しています。
```
# docker container run -it --name "test1" centos /bin/cal
```
```
      July 2020
Su Mo Tu We Th Fr Sa
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30 31
```
次でコンテナ内にログインできます。
```
# docker container run -it --name "test2" centos /bin/bash
```
## § コンテナのバックグラウンド実行(docker container run)
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--detach, -d|バックグラウンド実行する|
|--user, -u|ユーザ名を指定|
|--restart=[no \| onfailure \| on-failure:回数n \| always \| unless-stopped]|コマンドの実行結果によって再起動を行う|
|--rm|コマンド実行完了時にコンテナを自動で削除|
```
# docker container run -d centos /bin/ping localhost
```
### docker container start コマンド
停止中のコンテナを起動します。
### docker container stop コマンド
起動中のコンテナを停止します。
### docker container rm コマンド
(停止している)コンテナを削除します。
