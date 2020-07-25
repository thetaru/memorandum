# Docker
## § INSTALL
[公式](https://docs.docker.com/engine/install/centos/)を参照してください。  
バージョンや依存関係でインストールできない場合は[ここ](https://download.docker.com/linux/)からパッケージを探します。
```
# yum -y install https://download.docker.com/linux/<path_to_rpm>
```

## § COMMAND
### docker container run コマンド
Dockerコンテナを作成/実行します。
```
# docker container run [option] docker-image[:tag] [argument]
```
|オプション|意味|
|:---:|:---:|
|--attach, -a|標準入力/標準出力/標準エラー出力にアタッチする|
|--cidfile|コンテナIDをファイルに出力する|
|--detach, -d|コンテナを作成し、バックグラウンドで実行する|
|--tty, -t|端末デバイスを使う|

### docker version コマンド
```
# docker version
```
