# pytest
https://www.m3tech.blog/entry/pytest-summary
## ■ Install
以下のコマンドで`unittest`で書かれたテストも実行できます。
```
# pip3 install pytest
```
## ■ 使い方
`test_`で始まる関数や`Test`で始まるクラスがテスト対象になります。  
基本的な書き方は以下の通りです。
- テストは関数として定義
- assert文で検証
#### 例
```
def test_func(x, y):
    assert f() == 4
```
## ■ 実行
```
# pytest <テストファイル>.py
```
