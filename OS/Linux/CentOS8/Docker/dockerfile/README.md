# Dockerfile
# Dockerfileの基本文法
## Syntax
```
命令 引数
```
|命令|意味|
|:---|:---|
|FROM|ベースイメージの指定|
|RUN|コマンドの実行|
|CMD|コンテナの実行コマンド|
|LABEL|ラベルを設定|
|EXPOSE|ポートのエクスポート|
|ENV|環境変数|
|ADD|ファイル/ディレクトリの追加|
|COPY|ファイルのコピー|
|ENTRYPOINT|コンテナの実行コマンド|
|VOLUME|ボリュームのマウント|
|USER|ユーザの指定|
|WORKDIR|作業ディレクトリ|
|ARG|Dockerfile内の変数|
|ONBUILD|ビルド完了時に実行される命令|
|STOPSIGNAL|システムコールシグナルの設定|
|HEALTHCHECK|コンテナのヘルスチェック|
|SHELL|デフォルトシェルの設定|
