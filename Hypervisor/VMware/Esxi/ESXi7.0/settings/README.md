# Settings
(なるべく)vSphere Web Clientを使用せず、CUIのみを使って設定する。  
必要に応じて、コマンドにより反映される箇所を記載する。
## ■ 事前準備
vSphere Web ClientからESXiサーバにログインし、`[ホスト]-[管理]-[サービス]`より`TSM-SSH`サービスを起動する。

## ■ ホスト名の設定
```
esxcli system hostname set --host <ホスト名>
```

## ■ ドメイン名の設定
```
esxcli system hostname set --domain <ドメイン名>
```
