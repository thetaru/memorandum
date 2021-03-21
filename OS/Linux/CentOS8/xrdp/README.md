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
### 各種設定
大体の設定は以下ファイルをいじればどうにかなると思います。
```
# vi /etc/xrdp/sesman.ini
```
```
# vi /etc/xrdp/xrdp.ini
```
### 自動パッケージアップデートの無効化
```
# systemctl stop packagekit
# systemctl stop packagekit-offline-update.service
# systemctl mask packagekit
# systemctl mask packagekit-offline-update.service
```
### ポート解放
念の為何番ポートを使用しているか確認します。
```
# lsof -i -n -P | grep xrdp
```
firewallを導入している場合は確認したポート(デフォルトだと`3389/tcp`)をあけましょう。
