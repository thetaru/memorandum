# デーモンの実行
## Syntax
```
CMD [exec command]
```
### CMD命令の3通りの記述方法
#### 1. Exec形式での記述
シェルを介さずに実行します。
```
CMD ["nginx", "-g", "daemon off;"]
```
#### 2. Shell形式での記述
シェルを介して実行します。
```
CMD nginx -g 'daemon off;'
```
#### 3. ENTRYPOINT命令のパラメータでの記述
ENTRYPOINT命令の引数としてCMD命令を使うことができます。
## e.g.