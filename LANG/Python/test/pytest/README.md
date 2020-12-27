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
### 例
```
### test_foo.py
def f():
    return 3

def test_func():
    """f()の戻り値を検証する"""
    assert f() == 3
```
```
### test_class.py
class TestClass:
    def test_one(self):
        x = "this"
        assert "h" in x
        
    def test_two(self):
        x = "hello"
        assert hasattr(x, "check")
```
## ■ 実行
```
# pytest <テストファイル>.py
```
### 例
```
# pytest test_foo.py
```
