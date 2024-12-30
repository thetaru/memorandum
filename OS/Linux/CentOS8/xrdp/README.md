# xrdp
## xrdpパッケージ
### パッケージのインストール
```sh
# EPELリポジトリの追加(リポジトリが登録されていない場合)
yum install epel-release
# xrdpパッケージの追加
yum install xrdp tigervnc-server
```
## xrdpサービス
### サービスの起動
```sh
systemctl start xrdp
```
### サービス自動起動の有効化
```sh
systemctl enable xrdp
```
## xrdpの設定
### /etc/xrdp/xrdp.ini
### /etc/xrdp/sesman.ini
### /etc/X11/Xwrapper.config
```diff
# コンソールにログインしていないユーザーでもXサーバーを使用できるようにする(ここでは簡単のため任意のユーザに変更してる)
- allowed_users=console
+ allowed_users=anybody
+ needs_root_rights=no
```
