# セキュアNFSサーバの構築
## ■ 構想
### nfsクライアントの作成
いわゆるnobodyユーザを作成する  
もちろんuid/gidは固定する(サーバ・クライアントでそろえる必要がある)

### NFSv4専用
v3は完全無効へ

### rpcbind.serviceの停止(mask)
