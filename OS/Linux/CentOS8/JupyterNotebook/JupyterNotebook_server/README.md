# Jupyter Notebookサーバの構築
## ■ 事前準備
```
### サービス用ユーザの作成
# useradd -k /dev/null -s /sbin/nologin -d /opt/jupyter jupyter

### 設定ファイル格納用ディレクトリの作成(ログイン不可なのでbashを指定して実行)
# su -s /bin/bash - jupyter -c 'mkdir ~/.jupyter/'
```
## ■ インストール
```
### pipのインストール
# yum install python3-pip

### notebookのインストール
# su -s /bin/bash - jupyter -c "pip3 install -U pip --user"
# su -s /bin/bash - jupyter -c "pip3 install -U notebook --user"
```
## ■ バージョンの確認
```
### python
# python3 --version

### notebook
# su -s /bin/bash - jupyter -c "jupyter notebook --version"
```
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 主設定ファイル /opt/jupyter/.jupyter/jupyter_notebook_config.py
```py

c = get_config()

### 接続元IPの制限
c.NotebookApp.ip = '*'

### token passwordの設定(パスワードなしは非推奨)
c.NotebookApp.token = ''
c.NotebookApp.password = ''

### [Option] ディレクトリの指定(無効化する場合はコメントアウト)
c.NotebookApp.notebook_dir = '/opt/jupyter'

### ブラウザの立ち上げ
c.NotebookApp.open_browser = False

### Quitボタンを隠す
c.NotebookApp.quit_button = False

### terminalメニューを無効化
c.NotebookApp.terminals_enabled = False

### ポート指定
c.NotebookApp.port = 8888
```
## ■ セキュリティ
### ● firewall
## ■ ロギング
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
