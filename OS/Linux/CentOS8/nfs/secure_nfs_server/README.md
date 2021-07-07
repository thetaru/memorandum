# セキュアNFSサーバの構築
## ■ nfsv4の方針
NFSv4では、NFSサーバ上に公開するディレクトリルートを1つ決め、その下にあるディレクトリを公開します。  
しかし、公開したいディレクトリがNFSサーバのファイルシステムで必ずしも1つのディレクトリツリーにあるとは限りません。  
その場合は、mount --bindで公開するディレクトリルートの下に公開したいディレクトリを置きます。
## ■ nfsクライアントの作成
いわゆるnobodyユーザを作成する  
もちろんuid/gidは固定する(サーバ・クライアントでそろえる必要がある)

## ■ NFSv4専用
v3は完全無効へ

## ■ rpcbind.serviceの停止
```
# systemctl disable --now rpcbind.socket
# systemctl disable --now rpcbind.service
```

## ■ ファイアウォール
NFSv3と違いポート固定は不要です。  
2049/tcpを開けてあげる必要があります。  
rpc.mountは必要?
```
```
