# SERVFAIL時の対処
見るべきポイント
## 時刻同期の確認
時刻同期がとれてないと名前解決が失敗します。
```
# date
```
## キャッシュの確認
まずはキャッシュを出力します。
```
# rndc dumpdb -cache
```
SERVFAIL cacheやBad cacheあたりを調査してみましょう。  
以下コマンドだと全キャッシュ削除するので注意です。
```
# rndc flush
```
