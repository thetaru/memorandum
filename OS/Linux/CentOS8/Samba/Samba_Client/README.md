# sambaクライアントの設定
## ■ トラブルシューティング
```
同じユーザーによる、サーバーまたは共有リソースへの複数のユーザー名での複数の接続は許可されません。
```
同一クライアントから複数ユーザでログインしようとすると吐かれます。  
接続済みユーザが握っているコネクションを切ってから別ユーザで再接続すると繋がります。
```
> net use * /delete
```
## Ref
https://qiita.com/hana_shin/items/e768ef63bdeeef3ada39  
https://www.rem-system.com/samba-access-setting-01/
