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
# docker system df
# docker system df -v
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
### docker image ls
取得したイメージの一覧表示をします。
```
# docker image ls [option] [repository]
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1e4467b07108        20 hours ago        73.9MB
```
|オプション|意味|
|:---|:---|
|-all, -a|すべてのイメージを表示|
|--digests|ダイジェストを表示するかどうか|
|--no-trunc|結果をすべて表示する|
|--quiet, -q|DockerイメージIDのみ表示|
