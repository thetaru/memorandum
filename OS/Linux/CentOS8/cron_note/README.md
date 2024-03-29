# cronについて
## ■ バージョン確認
```
# crontab -V
```
## ■ サービスの確認
```
# systemctl status crond.service
```
## ■ ジョブの追加・削除
### ● バックアップ
```
### ジョブの実行ユーザがログインユーザの場合
# crontab -l > ~/crontab-$(date +%Y%m%d).bk

### ジョブの実行ユーザを指定する場合
# crontab -u <user> -l > ~/crontab-$(date +%Y%m%d).bk
```
### ● ジョブの編集
```
### ジョブの実行ユーザがログインユーザの場合
# crontab -e

### ジョブの実行ユーザを指定する場合
# crontab -u <user> -e
```
```
+  00 20 * * 1-5 /usr/bin/systemctl stop  squid.service
+  00 09 * * 1-5 /usr/bin/systemctl start squid.service
```
※ パスは例外を除き絶対パスで記述すること。また、シェルを実行する場合は実行権限があることを確認する。

## ■ 注意事項
### ● 条件がorになる
日と曜日が同時に指定された(\*でない)場合、orとして処理されます。  
例えば、以下の設定の場合
```
0 0 13 * 5 hoge
```
毎月13日または金曜日の0時0分に実行されます。
### ● cronの実行順序
時刻にマッチしたジョブが複数ある場合、それらのジョブは非同期実行されます。 
### ● 重い処理のバッティングを避ける
いろんなプロセスが走る時間帯にcronが実行されるのは避けましょう。  
例えば、データバックアップ中にそのバックアップ領域にさわるような処理を実行する行為はNGです。
