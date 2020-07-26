# docker image pull
Docker Hubからイメージをダウンロードします。
## Syntax
```
# docker image pull [option] docker-iamge[:tag]
```
### e.g.
#### ubuntuのイメージ取得
```
# docker image pull ubuntu:latest
```
```
latest: Pulling from library/ubuntu
wwwwwwwwwwww: Pull complete
xxxxxxxxxxxx: Pull complete
yyyyyyyyyyyy: Pull complete
zzzzzzzzzzzz: Pull complete
Digest: sha256:0123456789012345678901234567890123456789
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest
```
#### CentOSのすべてのタグのイメージ取得
```
# docker image pull -a centos
```
#### TensorFlowのURLを指定してイメージ取得
URLを使う場合は、http(s)を取って指定します。
```
# docker image pull gcr.io/tensorflow/tensorflow
```
