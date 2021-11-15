# HAProxyサーバの構築
## ■ インストール
最新版を入れる場合はソースからビルドする必要があります。
```
# yum install haproxy
```
## ■ バージョンの確認
```
# haproxy -v
```

## ■ サービスの起動
サービスの起動と共に自動起動の有効化もします。
```
# systemctl enable --now haproxy.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|haproxy.service|任意/tcp||

## ■ 主設定ファイル haproxy.cfg
### ● 設定項目
#### globalセクション
このセクションで設定するパラメータは、HAProxyプロセス全体の共通パラメータとなります。  
globalセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/global_keywords)にまとめました。
#### defaultsセクション
このセクションで設定するパラメータは、各セクションのデフォルトパラメータとなります。  
defaultsセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/defaults_keywords)にまとめました。
#### frontendセクション
クライアントからの通信を受け付けるIPアドレス(VIP)・ポート番号を設定します。  
frontendセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/frontend_keywords)にまとめました。
#### backendセクション
負荷分散方式や負荷分散先のサーバが受け付けるIPアドレス・ポート番号を設定します。  
backendセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/backend_keywords)にまとめました。

### ● 文法チェック
```
# haproxy -f /etc/haproxy/haproxy.cfg -c
```
## ■ セキュリティ
## firewall
- 任意/tcp

## 証明書
クライアント-HAProxyサーバ間をSSL通信でやりとりします。(HAProxyサーバ-バックエンドサーバ間は非SSL通信)  
※ SSL終端として動作する必要があるため、L7のロードバランサでなくてはいけません
## 認証
## ■ ロギング
### ● rsyslog
デフォルトの設定ではchroot環境のため、ひと手間加えます。
```
# mkdir -p /var/lib/haproxy/dev

# cat << EOF > /etc/rsyslog.d/haproxy.conf
$AddUnixListenSocket /var/lib/haproxy/dev/log
if ($programname startswith "haproxy") then {
  action(type="omfile" file="/var/log/haproxy.log")
  stop
}
EOF

# vi /etc/haproxy/haproxy.cfg
-  log         127.0.0.1 local2
+  log         /dev/log local2

# systemctl restart haproxy
# systemctl restart rsyslog
```
### ● logrotate
```
# cat << EOF > /etc/logrotate.d/haproxy
/var/log/haproxy/haproxy.log {
    dateext
    daily
    missingok
    rotate 7
    notifempty
    compress
    sharedscripts
    postrotate
        /bin/kill -HUP \`cat /var/run/rsyslogd.pid 2> /dev/null\` 2> /dev/null || true
    endscript
}
EOF
```
## ■ チューニング
### ● プロセス数
HAProxyはデフォルトだとシングルプロセスのみを使用してリクエストを処理するため、1つのCPUしか利用しません。  
複数のCPUを使う場合は、HAProxyのプロセス数を増やし、それぞれを別のCPUに割り当てるよう設定します。  
利用可能なCPUは`lshw -short -class cpu`、コアあたりのスレッド数は`lscpu`により取得できます。  
※ HAProxyの推奨設定は、プロセス数1としている
```
# システム上のCPU数: 6 (1CPU あたり 1コア 2スレッド) (CPU: 0-5)
# システム上の合計スレッド数: 6(CPU数) * 1(1CPUあたりのコア数) * 2(1コアあたりのスレッド数) = 12 
global
    (snip)
    # プロセス数を設定 (HAProxy process: 1-6)
    nbproc 6
    # スレッド数を設定 (thread: 1-12)
    nbthread 12
    # プロセスをCPUに割り当てる (process_range/thread_range cpu_range)
    cpu-map auto:1/1-2   0
    cpu-map auto:2/3-4   1
    cpu-map auto:3/5-6   2
    cpu-map auto:4/7-8   3
    cpu-map auto:5/9-10  4
    cpu-map auto:6/11-12 5
    # 統計情報取得の役割を持たせるプロセスを指定する(?)
    stats bind-process 1
    (snip)
```
CPU周りは物理マシンと仮想マシンで扱いが結構かわるので注意したほうがよさそう  
※ 物理だとNUMA見れるけど、仮想だとみれないとか

### ● ファイルディスクリプタ数
```
globalセクションよりulimit-nオプションで設定可能(ドロップインファイルを作成しないでOK)
```
### ● コネクション数
```
各セクションごとにmaxconnオプションで設定可能
```

## ■ 設定の反映
```
# systemctl restart haproxy.service
```
