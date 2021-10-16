# 単体テスト
## ■ 概要
単体テストでは、詳細設計書と構築したサーバの設定値を比較し、差分がないことを確認する。  
以下では、OS部分と機能部分のテストを行う。

## ■ 観点
### 事前準備
```
### 単体テストで取得するファイルを格納するディレクトリを作成
$ mkdir -p ~/work/$(date +%Y%m%d)_UnitTest_01
$ cd ~/work/$(date +%Y%m%d)_UnitTest_01
```
以降、特に指定しなければ、`~/work/$(date +%Y%m%d)_UnitTest_01`で作業する。
### OSとカーネルバージョンを確認
```
$ uname -a > ./systeminfo_$(date +%Y%m%d).log
```
### ディストリビューションの確認
```
$ cat /etc/os-release > ./distribution_$(date +%Y%m%d).log
```
### メモリの確認
```
$ lsmem > ./mem_$(date +%Y%m%d).log
```
### CPUの確認
```
$ lscpu > ./cpu_$(date +%Y%m%d).log
```
### ブロックデバイスの確認
```
$ lsblk -f -o +MIN-IO,SIZE,STATE > ./disk_$(date +%Y%m%d).log
```
### パッケージ一覧の確認
不要なパッケージがないことを確認する。
```
$ rpm -qa | sort > ./package_$(date +%Y%m%d).log
```
### サービス一覧の確認
不要なサービスがないことを確認する。
```
$ systemctl list-unit-files --no-pager -t service > ./service_$(date +%Y%m%d).log
```
### ユーザ・グループの確認
```
$ cat /etc/passwd > ./user_$(date +%Y%m%d).log
$ cat /etc/group > ./group_$(date +%Y%m%d).log
```
### ネットワークインターフェースの状態確認
```
$ ethtool ens192 > ./interface_status_$(date +%Y%m%d).log
```
### ネットワークインターフェースの設定確認
```
$ nmcli connection show > ./interface_connections_$(date +%Y%m%d).log
$ nmcli connection show ens192 > ./interface_settings_$(date +%Y%m%d).log
```
### ファイアウォールの確認
詳細設計書どおりのルールを適用していることを確認する。  
ファイアウォールの設定方法が複数あるため、コマンドは省略する。
### SSHの設定確認
rootでのSSHログインが不可であることを確認する。
```
$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost
```
### 設定ファイル情報の確認
ファイルのパーミッションと所有権が適切であることを確認する。
```
$ ls -l /etc/XXX.conf > ./file_permission_$(date +%Y%m%d).log
$ ls -l /etc/YYY.cfg >> ./file_permission_$(date +%Y%m%d).log
```
### 設定ファイルの取得
構築したサーバで詳細設計書と構築したサーバの設定値を比較した後、エビデンスとして手を入れた設定ファイルを取得する。  
※ ちゃんとデフォルトの設定ファイルをとっている場合、そのファイルと設定後のファイルをdiffしてもOKです
```
### 取得するファイルを単体テスト用のディレクトリにコピー
$ cp -p /etc/XXX.conf ./
$ cp -p /etc/YYY.cfg ./
...(上と同様に、対象ファイルをコピーする)
```
### まとめ
```
### 取得したファイルをtar.gzで固める
$ tar cvfz configs_$(date +%Y%m%d).tar.gz *
```
