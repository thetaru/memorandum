# GitLabサーバ
## ■ Install
### 1. パッケージインストール
```
### Gitlabレポジトリの追加
# curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
```
```
### GitLabをインストール
# yum install -y gitlab-ce
```
### 2. GitLabの設定
GitLabにアクセスするときのURLを設定します。
```
# vi /etc/gitlab/gitlab.rb
```
```
### URLを指定
-  external_url 'http://gitlab.example.com'
+  external_url 'http://<ホスト名 or IPアドレス>'
```
### 3. 設定の反映
```
# gitlab-ctl reconfigure
```
### 4. Firewallの設定
firewalldを無効化しているなら以下の設定は不要です。
```
### httpsを使用するならhttp→https
# firewall-cmd --add-service=http --zone=public --parmanent
# firewall-cmd --reload
```
## ■ コマンド集
```
### gitlabサーバの起動
# gitlab-ctl start

### gitlabサーバの停止
# gitlab-ctl stop

### gitlabサーバの再起動
# gitlab-ctl restart
```
