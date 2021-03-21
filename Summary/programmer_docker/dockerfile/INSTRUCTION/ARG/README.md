# Dockerfile内変数の設定
## Syntax
```
ARG <名前>[=デフォルト値]
```
### e.g.
#### ARG命令の例
```
### 変数の定義
ARG NAME="thetaru"

RUN echo $NAME
```
