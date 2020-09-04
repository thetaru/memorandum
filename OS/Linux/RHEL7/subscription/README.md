# サブスクリプション登録
:warning: vCetner管理下のEsxi上のRHELサーバに対してサブスクリプション登録をする場合は事前にvirt-whoの設定をする必要があります。  
:warning: virt-whoの設定後、RHNのweb画面から各Esxiに対して適切なサブスクリプションを割り当てます。
## § サブスクリプション確認
```
# subscription-manager list
```
```
+-------------------------------------------+
    インストール済み製品のステータス
+-------------------------------------------+
製品名:           Red Hat Enterprise Linux Server
製品 ID:          69
バージョン:       7.x
アーキテクチャー: x86_64
状態:             不明
状態の詳細:
開始:
終了:
```
## § システム登録
```
### プロキシありの場合
# subscription-manager config --server.proxy_hostname=proxy.example.com --server.proxy_port=8080

# subscription-manager register
```
```
ユーザー名: <RHNに登録しているユーザー名>
パスワード: <上記ユーザーのパスワード>
このシステムは、次の ID で登録されました: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
登録されたシステム名: <ホスト名>
```
## § Pool IDの確認
```
### Pool IDを確認
# subscription-manager list --available
```
```
...
プール ID:                xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
...
```
## § サブスクリプション割り当て
```
### 割り当て対象のサブスクリプションのPool IDを入れて実行
# subscription-manager subscribe --pool=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
```
サブスクリプションが正しく割り当てられました: <サブスクリプション名>
```
## § 割り当て確認
```
# subscription-manager list --consumed
```
```
製品名:           Red Hat Enterprise Linux Server
製品 ID:          69
バージョン:       7.x
アーキテクチャー: x86_64
状態:             サブスクライブ済み
状態の詳細:
開始:             aa/bb/cccc
終了:             xx/yy/zzzz
```
※ RHNからも確認することができます。
