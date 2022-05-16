# ローカルミラー
公式リポジトリからパッケージをダウンロードして、ローカルにミラーサーバを構築する。

## ■ パッケージのインストール
```
# yum install yum-utils createrepo httpd
```

## ■ パッケージ格納用ディレクトリの作成
ここでは、ディレクトリの命名規則を`/var/www/repo/<ディストリ>/<バージョン>`とする。
```
# mkdir -p /var/www/repo/centos/8
```

## ■ 公式リポジトリとの同期
```
# reposync -p <download-path> --download-metadata --repo=<repo id>

### CentOS8
# reposync -p /var/www/repo/centos/8/ --download-metadata --repo=baseos
# reposync -p /var/www/repo/centos/8/ --download-metadata --repo=appstream
```

## ■ リポジトリの作成
```
# createrepo -v /var/www/repo/centos/8/centos-8-server-rpms/ -g comps.xml
```
※ gオプションでgroupinstallが可能となる

## ■ apacheの設定
```
# vi /etc/httpd/conf/httpd.conf
```
```
<Directory />
    #AllowOverride none
    AllowOverride All
    Require all denied
</Directory>
```
```
# vi /etc/httpd/conf.d/repos.conf
```
```
Alias /repo /var/www/repo
<directory /var/www/repo>
    Options +Indexes
    Require all granted
</directory>
```
## ■ パッケージの定期アップデート
cronで同期するコマンドを実行する。
