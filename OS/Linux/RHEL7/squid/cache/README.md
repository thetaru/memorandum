# キャッシュについての設定
## 特定のページをキャッシュから除外
ある特定のページをキャッシュから除外する場合は次のようにします。
```
# github.comをキャッシュしない例
acl QUERY urlpath_regex cgi-bin \? github.com
no_cache deny QUERY
```
## Keep-Aliveの無効化
デフォルトではTCPコネクションを維持してしまうので、コネクションを切るには以下の設定を入れます。
```
client_persistent_connections off
server_persistent_connections off
```
注意点としては、サーバ・クライアント間のコネクションが大量に作成・削除が行われるためサーバに負荷がかかります。  
そのため、コネクションに関するチューニングも行いましょう。
## キャッシュ機能を無効化する方法
動的に更新されるWebページに対して、キャッシュされた情報が影響してうまく表示ができない場合があります。  
回線速度が十分に出ている場合はキャッシュを使わないというのも手だと思います。
```
acl NOCACHE src all
cache deny NOCACHE
```
