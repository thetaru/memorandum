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
#### CentOSのすべてのタグのイメージ取得
```
# docker image pull -a centos
```
#### TensorFlowのURLを指定してイメージ取得
URLを使う場合は、http(s)を取って指定します。
```
# docker image pull gcr.io/tensorflow/tensorflow
```
