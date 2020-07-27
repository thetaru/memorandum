# コマンドの実行
## Syntax
```
RUN [exec command]
```
### RUN命令の2通りの記述方法
#### 1. Shell形式での記述
```
# Nginxのインストール
RUN apt-get install -y nginx
```
#### 2. Exec形式での記述
```
# Nginxのインストール
RUN ["/bin/bash", "-c", "apt-get install -y nginx"]
```
## e.g.
### RUN命令の実行ログ
```
# docker build -t run-sample .
```
```
実行結果
```