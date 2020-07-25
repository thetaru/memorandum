# Docker
## § INSTALL
[公式](https://docs.docker.com/engine/install/centos/)を参照してください。  
バージョンや依存関係でインストールできない場合は[ここ](https://download.docker.com/linux/)からパッケージを探します。
```
# yum -y install https://download.docker.com/linux/<path_to_rpm>
```

## § COMMAND
### docker container run コマンド
Dockerコンテナを作成/実行します。
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

### docker version コマンド
```
# docker version
```
### docker system info コマンド
```
# docker system info
```
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
### docker image pull コマンド
イメージのダウンロードをします。
```
# docker image pull [option] docker-iamge[:tag]
```
#### e.g.
```
# docker image pull ubuntu:latest
```
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
