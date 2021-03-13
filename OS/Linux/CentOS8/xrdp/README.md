# xrdp
## xrdpのインストール
epelリポジトリが登録されていない場合は次を実行します。
```
# yum install epel-release
```
```
# yum install xrdp tigervnc-server 
```
サービスの起動と自動起動の有効化
```
# systemctl start xrdp
# systemctl enable xrdp
# systemctl status xrdp
```
## xrdpの設定
### 自動パッケージアップデートの無効化
```
# systemctl stop packagekit
# systemctl stop packagekit-offline-update.service
# systemctl mask packagekit
# systemctl mask packagekit-offline-update.service
```
### ポート解放
firewallを導入している場合は`3389/tcp`をあけましょう。
