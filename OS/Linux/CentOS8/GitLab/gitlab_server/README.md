# Gitlabサーバの構築
## ■ 前提条件
|項目|設定値|
|:---|:---|
|Hypervisor|vSphere 6.8|
|OS|CentOS8|
|CPU|4|
|MEM|4|
|Storage|200GB|
|Software|Gitlab 13.5.4-ee|

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
### 5. サービスの設定
```
### サービスの自動起動の有効化
### 初回のときはすでに起動済みだと思いますが念のため実行
# systemctl start gitlab-runsvdir.service
# systemctl enable gitlab-runsvdir.service
```
## ■ コマンド集
```
### バージョン確認
# gitlab-rake gitlab:env:info
```
```
### gitlabサーバの起動
# gitlab-ctl start

### gitlabサーバの停止
# gitlab-ctl stop

### gitlabサーバの再起動
# gitlab-ctl restart
```
