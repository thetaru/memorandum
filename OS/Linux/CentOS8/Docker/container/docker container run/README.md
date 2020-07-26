# コンテナの生成/起動
## Syntax
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--attach, -a|標準入力/標準出力/標準エラー出力にアタッチする|
|--cidfile|コンテナIDをファイルに出力する|
|--detach, -d|コンテナを作成し、バックグラウンドで実行する|
|--interactive, -i|コンテナの標準入力を開く|
|--name|コンテナの名前を指定する|
|--tty, -t|端末デバイスを使う|
### e.g.
#### echoコマンドを実行してHello Worldを出力
```
# docker container run -it --name "test1" centos /bin/echo "Hello World"
```
```
Hello World
```
#### bashの実行
```
# docker container run -it --name "test2" centos /bin/bash
```
# コンテナのバックグラウンド実行
## Syntax
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--detach, -d|バックグラウンド実行する|
|--user, -u|ユーザ名を指定|
|--restart=[no \| onfailure \| on-failure:回数n \| always \| unless-stopped]|コマンドの実行結果によって再起動を行う|
|--rm|コマンド実行完了時にコンテナを自動で削除|
### e.g.
#### pingコマンドの実行によりコンテナのバックグラウンド起動
```
# docker container run -d centos /bin/ping localhost
```
#### コンテナの常時再起動
コンテナ内で/bin/bashをexitコマンドで終了しても自動でコンテナを再起動します。
```
# docker container run -it --restart=always centos /bin/bash
```
```
[root@3878be285b91 /]# exit
exit
```
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         40 seconds ago      Up 35 seconds                           clever_wiles
```
# コンテナのネットワーク設定
## Syntax
```
# docker container run [network-option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--add-host=[ホスト名:IPアドレス]|コンテナの/etc/hostsにホスト名とIPアドレスを定義する|
|--dns=[IPアドレス]|コンテナ用のDNSサーバのIPアドレス指定|
|--expose|指定したレンジのポート番号を割り当てる|
|--mac-address=[MACアドレス]|コンテナのMACアドレスを指定する|
|--net=[bridge \| none \| container:<name \| id> \| host \| NETWORK]| コンテナのネットワークを指定する|
|--hostname, -h|コンテナ自身のホスト名を指定する|
|--publish, -p[ホストのポート番号]:[コンテナのポート番号]|ホストとコンテナのポートマッピング|
|--publish-all, -P|ホストの任意のポートをコンテナに割り当てる|
### e.g.
#### コンテナのポートマッピング
```
# docker container run -d -p 8080:80 nginx
```
#### コンテナのDNSサーバ指定
```
# docker container run -d --dns 192.168.1.1 nginx
```
#### MACアドレスの指定
```
# docker container run -d --mac-address="92:d0:c6:0a:29:33" centos
```
```
8473c0da13f0c31735c9f7314580688cbb61d26b9414d568daee379ecf89adb3
```
```
# docker container inspect --format="{{ .Config.MacAddress }}" 8473c0da13f0c31735c9f7314580688cbb61d26b9414d568daee379ecf89adb3
```
```
92:d0:c6:0a:29:33
```
#### ホスト名とIPアドレスを定義
```
# docker container run -it --add-host test.com:192.168.1.1 centos
```
```
[root@9f5b5ee2dd2b /]# cat /etc/hosts
```
```
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
192.168.1.1     test.com
172.17.0.4      9f5b5ee2dd2b
```
#### ホスト名の設定
```
# docker container run -it --hostname www.test.com --add-host node1.test.com:192.168.1.1 centos
```
```
[root@www /]# hostname
www.test.com
```
```
[root@www /]# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
192.168.1.1     node1.test.com
172.17.0.3      www.test.com www
```
# リソースを指定したコンテナの生成/実行
## Syntax
```
# docker container run [resource option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--cpu-shares, -c|CPUの使用の配分|
|--memory, -m|使用するメモリを制限して実行する|
|--volume=[ホストのディレクトリ]:[コンテナのディレクトリ], -v|ホストとコンテナディレクトリを共有|
### e.g.
#### CPU時間の相対割合とメモリの使用量を指定
```
# docker container run --cpu-shares=512 --memory=1g centos
```
# コンテナを生成/起動する環境を指定
## Syntax
```
# docker container run [env option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---|:---|
|--env=[環境変数], -e|環境変数を設定する|
|--env-file=[ファイル名]|環境変数をファイルから設定する|
|--readonly=[true \| false]|コンテナのファイルシステムを読み込み専用にする|
|--workdir=[パス], -w|コンテナの作業ディレクトリを指定する|
|-u, -user=[ユーザ名]|ユーザ名またはUIDを指定する|
### e.g.
#### 環境変数の設定
```
# docker container run -it -e foo=bar centos /bin/bash
```
```
[root@0766efa1f355 /]# set | grep foo
```
```
foo=bar
```
#### 環境変数の一括設定
```
# cat env_list
```
```
hoge=fuga
foo=bar
```
```
# docker container run -it --env-file=env_list centos /bin/bash
```
```
[root@b28ad1826715 /]# set | grep -e hoge -e foo
```
```
foo=bar
hoge=fuga
```
