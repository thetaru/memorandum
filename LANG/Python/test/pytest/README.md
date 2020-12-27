# pytest
https://www.m3tech.blog/entry/pytest-summary
## ■ インストール
以下のコマンドで`unittest`で書かれたテストも実行できます。
```
# pip3 install pytest
```
## ■ 基本的な使い方
`test_`で始まる関数や`Test`で始まるクラスがテスト対象になります。  
書き方は以下の通りです。
- テストは関数として定義
- assert文で検証

ルールは以下の通りです。
- テストファイル名が`test_*.py`または`*_test.py`であること
- テスト関数名に`test`が付くこと
### 例
```
### test_foo.py
def f():
    return 3

def test_func():
    """f()の戻り値を検証する"""
    assert f() == 3
```
テスト関数をクラスにまとめることもできます。  
unittestと違い、`unittest.TestCase`を継承する必要はありません。
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
`pytest`コマンドでテストを実行します。
```
# pytest test_foo.py
```
## ■ pytestの例外テスト
## ■ pytestのsetupとteardown
## ■ pytestのスキップ
## ■ テストファイルの配置
- テストファイルは`src/tests/`ディレクトリ下にまとめる
- テスト対象のコードと対応する名前を付ける(e.g. テスト対象コードが`app.py`にあるなら`test_app.py`と付ける)
