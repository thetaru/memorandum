# Keep-Alive
## Keep-Aliveの無効化
デフォルトではTCPコネクションを維持してしまうので、コネクションを切るには以下の設定を入れます。
```
client_persistent_connections off
server_persistent_connections off
```
注意点としては、サーバ・クライアント間のコネクションが大量に作成・削除が行われるためサーバに負荷がかかります。  
そのため、コネクションに関するチューニングも行いましょう。
`curl -I`でHTTPレスポンスヘッダからConnectionをみてみる。
