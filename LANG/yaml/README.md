# YAML入門
# 意味
## スカラ
`:`で区切られた"名前"の列挙を`スカラ`という。
```yaml
name1: 
name2: 
```
## マッピング
スカラに値を紐づける。
```yaml
name1: test1
name2: test2
```
## シーケンス
先頭に`-`をつけた場合には、配列になる。
```yaml
- name1:
- name2:
```
## コレクション
インデントによって、階層を表現する。
```yaml
- name: the 1st Example
  hosts: 172.17.0.2
  tasks:
    - name: Hello, World!
      dubug:
    - name: Next debug
      debug: msg="Hello, World"
```
python的にはこんな感じ
```py
[
  {name: the 1st Example},
  {hosts: 172.17.0.2},
  {tasks:
    [
      {name: Hello World},
      {debug: }
    ],
    [
      {name: Next debug},
      {debug: msg="Hello, World"}
    ]
  }
]
```
