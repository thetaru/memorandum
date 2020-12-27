# pytest
https://www.m3tech.blog/entry/pytest-summary
## ■ Install
以下のコマンドで`unittest`で書かれたテストも実行できます。
```
# pip3 install pytest
```
## ■ 使い方
`test_`で始まる関数や`Test`で始まるクラスがテスト対象になります。
#### 例
```
def test_calc(x, y):
    return x * y
    
class TestCalc(object):
    def test_calc(self):
    
```
## ■ 実行
```
# pytest <テストファイル>.py
```
