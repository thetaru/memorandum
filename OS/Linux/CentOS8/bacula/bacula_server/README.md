# Bacukaサーバの構築
Web GUIを導入するため
## ■ インストール
### ● MySQLのインストール
以下のコマンドでMySQLをインストールします。
```
# dnf module install mysql:8.0
```

### ● MySQLサーバの起動
```
# systemctl enable --now mysqld.service
# systemctl status mysqld.service
```

### ● MySQLサーバの初期化
mysql_secure_installationコマンドでMySQLサーバの初期化を実施します。
```
# mysql_secure_installation
```

### ● アクセスキーの取得
データベースのインストールが完了したらBaculaリポジトリのアクセスキーを取得します。

### ● Baculaのインストール
まず、レポジトリを作成します。  
[access_key]部分は取得したアクセスキーに書き換えてください。
```
# cat < EOF > /etc/yum.repos.d/Bacula.repo
[Bacula-Community]
name=CentOS - Bacula - Community
baseurl=http://bacula.org/packages/[access_key]/rpms/9.6.5/el8/x86_64/
enabled=1
protect=0
gpgcheck=0
EOF
```

```
# yum -y install bacula-mysql
```

```
# mysql -u root -p
```
```
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.17 Source distribution

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database bacula;
Query OK, 1 row affected (0.00 sec)

mysql> create user 'bacula'@'localhost' identified  by 'DBpass1!';
Query OK, 0 rows affected (0.00 sec)

mysql> grant all on bacula.* to 'bacula'@'localhost' with grant option;
Query OK, 0 rows affected (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

mysql> quit
```

```
# /opt/bacula/scripts/make_mysql_tables -uroot -p
```
```
Making mysql tables
Enter password: dbpass 　　　←rootのパスワードを入力
Creation of Bacula MySQL tables succeeded.
```

### ● [option] Baculumのインストール
BaculaのWeb GUIである`Baculum`をインストールします。
```
# cat < EOF > /etc/yum.repos.d/baculum.repo
[baculumrepo]
name=Baculum CentOS repository
baseurl=http://bacula.org/downloads/baculum/stable/centos
gpgcheck=1
enabled=1
EOF
```

## ■ バージョンの確認
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 事前準備系(特になければ消してok)

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● yyyディレクティブ
- aaa(recommended)
- bbb
### ● zzzパラメータ
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ロギング
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 参考
https://straypenguin.winfield-net.com/
