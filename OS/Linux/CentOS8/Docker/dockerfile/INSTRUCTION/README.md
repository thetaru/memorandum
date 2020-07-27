# INSTRUCTION
## Syntax
```
命令 引数
```
|命令|意味|
|:---|:---|
|FROM|ベースイメージの指定|
|[RUN](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/RUN)|コマンドの実行|
|[CMD](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/CMD)|コンテナの実行コマンド|
|LABEL|ラベルを設定|
|EXPOSE|ポートのエクスポート|
|[ENV](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ENV)|環境変数|
|ADD|ファイル/ディレクトリの追加|
|COPY|ファイルのコピー|
|[ENTRYPOINT](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ENTRYPOINT)|コンテナの実行コマンド|
|VOLUME|ボリュームのマウント|
|USER|ユーザの指定|
|[WORKDIR](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/WORKDIR)|作業ディレクトリ|
|ARG|Dockerfile内の変数|
|[ONBUILD](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ONBUILD)|ビルド完了時に実行される命令|
|[STOPSIGNAL](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/STOPSIGNAL)|システムコールシグナルの設定|
|[HEALTHCHECK](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/HEALTHCHECK)|コンテナのヘルスチェック|
|SHELL|デフォルトシェルの設定|
# Dockerfileの作成
## Syntax
```
FROM [docker-iamge]
FROM [docker-image]:[tag]
FROM [docker-image]:[digest]
```
## e.g.
### CentOS7をベースイメージにしたDockerfile
```
# ベースイメージの設定
FROM centos:centos7
```
### ダイジェストの確認
```
# docker image ls --digests tensorflow
```
