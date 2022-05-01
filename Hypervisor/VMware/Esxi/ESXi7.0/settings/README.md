# Settings
(なるべく)vSphere Web Clientを使用せず、CUIのみを使って設定する。
## ■ 事前準備
vSphere Web ClientからESXiサーバにログインし、`[ホスト]-[管理]-[サービス]`より`TSM-SSH`サービスを起動する。

## ■ ホスト名の設定
```
esxcli system hostname set --host <ホスト名>
```
`[ネットワーク]-[TCP/IP スタック]-[デフォルトの TCP/IP スタック]`に反映
## ■ ドメイン名の設定
```
esxcli system hostname set --domain <ドメイン名>
```
`[ネットワーク]-[TCP/IP スタック]-[デフォルトの TCP/IP スタック]`に反映


## ■ ネットワークの設定
### ポートグループ
### 仮想スイッチ
### VMkernel NIC
### TCP/IPスタック
## ■ データストア

## ■ ライセンスの設定
