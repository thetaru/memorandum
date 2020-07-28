# デフォルトシェルの設定
## Syntax
```
SHELL ["シェルのパス", "パラメータ"]
```
## e.g.
#### RUN命令の実行
```
### デフォルトシェルの指定
SHELL ["/bin/bash", "-c"]

### RUN命令の実行
RUN echo hello
```
デフォルトシェルが変わるとRUN命令,CMD命令,ENTRYPOINT命令で有効なります。
