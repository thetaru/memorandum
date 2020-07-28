# 作業ディレクトリの指定
## Syntax
```
WORKDIR [path_to_work-directory]
```
指定したディレクトリが存在しなければ、新たに作成されます。
## e.g.
### WORKDIR命令を使う例
```
### /firstが基点となった
WORKDIR /first
### /first/secondが作業ディレクトリになる
WORKDIR second
### /first/second/thirdが作業ディレクトリになる
WORKDIR third
### /first/second/thirdが出力される
RUN ["pwd"]
```
### WORKDIR命令とENV命令を使う例
```
ENV BASEPATH /first
ENV DIRNAME second
WORKDIR $BASEPATH/$DIRNAME
RUN ["pwd"]
```
