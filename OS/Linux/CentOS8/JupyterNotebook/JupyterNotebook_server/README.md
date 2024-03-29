# Jupyter Notebookサーバの構築
## ■ 事前準備
```
### サービス用ユーザの作成
# useradd -k /dev/null -s /sbin/nologin -d /opt/jupyter -m jupyter

### 設定ファイル格納用ディレクトリの作成
# mkdir -p /opt/jupyter/.jupyter
# mkdir -p /opt/jupyter/playground
# touch /opt/jupyter/.jupyter/jupyter_notebook_config.py
# chown -R jupyter:jupyter /opt/jupyter
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
## ■ 主設定ファイル /opt/jupyter/.jupyter/jupyter_notebook_config.py
```py

c = get_config()

### 接続元IPの制限
c.NotebookApp.ip = '*'

### token passwordの設定(パスワードなしは非推奨)
c.NotebookApp.token = ''
c.NotebookApp.password = ''

### ディレクトリの指定
c.NotebookApp.notebook_dir = '/opt/jupyter/playground'

### ブラウザの立ち上げ
c.NotebookApp.open_browser = False

### Quitボタンを隠す
c.NotebookApp.quit_button = False

### terminalメニューを無効化
c.NotebookApp.terminals_enabled = False

### ポート指定
c.NotebookApp.port = 8888
```
## ■ ユニットファイル /etc/systemd/system/jupyter.service
```
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple

ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/jupyter/playground
ReadWritePaths=/opt/jupyter/.local/share
PrivateTmp=true
WorkingDirectory=/opt/jupyter/playground
ExecStart=/opt/jupyter/.local/bin/jupyter-notebook --config=/opt/jupyter/.jupyter/jupyter_notebook_config.py

User=jupyter
Group=jupyter

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```
## ■ セキュリティ
### ● firewall
- 8888/tcp

## ■ ロギング
### /etc/rsyslog.conf
```
+  if $msg contains 'jupyter-notebook' then /var/log/jupyter-notebook.log
+  &stop
```
### /etc/logrotate.d/jupyter-notebook
```
/var/log/jupyter-notebook.log {
    compress
    dateext
    daily
    rotate 7
    notifempty
    missingok
}
```
## ■ サービスの起動
```
# systemctl daemon-reload
# systemctl enable --now jupyter.service
```
