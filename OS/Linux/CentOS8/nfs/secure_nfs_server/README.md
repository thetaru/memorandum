# セキュアNFSサーバの構築
## 構想
### ■ nfsクライアントの作成
いわゆるnobodyユーザを作成する  
もちろんuid/gidは固定する(サーバ・クライアントでそろえる必要がある)

### NFSv4専用
v3は完全無効へ

### ■ rpcbind.serviceの停止
```
# systemctl disable --now rpcbind.socket
# systemctl disable --now rpcbind.service
```

### ■ ファイアウォール
2049/tcpを開けてあげる必要があります。  
rpc.mountは必要?
```
```
