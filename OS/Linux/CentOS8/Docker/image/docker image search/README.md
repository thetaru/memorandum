# イメージの検索
## Syntax
```
# docker search [option] 検索キーワード
```
|オプション|意味|
|:---|:---|
|--no-trunc|結果をすべて表示する|
|--limit|n件の検索結果を表示する|
|--filter=stars=n|お気に入りの数(n以上)の指定|
### e.g.
#### docker hubに公開されているイメージの検索
```
NAME                               DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
nginx                              Official build of Nginx.                        13509               [OK]
...
```
|項目|意味|
|:---|:---|
|NAME|イメージ名|
|DESCRIPTION|イメージの説明|
|STARS|お気に入りの数|
|OFFICIAL|公式イメージかどうか|
|AUTOMATED|Dockerfileをもとに自動生成されたかどうか|
