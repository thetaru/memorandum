# 環境変数の設定
## Syntax
```
ENV [key] [value]
ENV [key]=[value]
```
### ENV命令の2通りの記述方法
#### 1. key value型で指定する場合
単一の環境変数(key)に単一の値(value)を割り当てます。
```
ENV Name "the"
ENV FullName the taru
ENV Age 99
```
#### 2. key=value型で指定する場合
一度に複数の環境変数を割り当てるときに使います。
```
ENV Name="the"\
    FullName=the\ taru \
    Age=99
```
