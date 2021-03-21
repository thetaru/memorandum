# イメージの一覧表示
## Syntax
```
# docker image ls [option] [repository]
```
|オプション|意味|
|:---|:---|
|-all, -a|すべてのイメージを表示|
|--digests|ダイジェストを表示するかどうか|
|--no-trunc|結果をすべて表示する|
|--quiet, -q|DockerイメージIDのみ表示|
## e.g.
### イメージの一覧表示
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1e4467b07108        20 hours ago        73.9MB
```
|項目|意味|
|:---|:---|
|REPOSITORY|イメージ名|
|TAG|イメージタグ名|
|IMAGE ID|イメージID|
|CREATED|作成日|
|SIZE|イメージのサイズ|
