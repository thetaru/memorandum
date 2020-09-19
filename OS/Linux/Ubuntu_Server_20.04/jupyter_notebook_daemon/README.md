# Jupyter Notebookをデーモンにする
## Jupyter Notebookのインストール
```
$ sudo apt install python3-pip
```
```
$ sudo apt install jupyter-notebook
```
## Jupyter Notebookの設定
Jupyter Notebookはrootで実行しないのでroot以外のユーザ`thetaru`を想定しています。
```
### [Option] Jupyter Notebookの起動時のディレクトリを作成(デフォルトは/home/thetaru)
$ sudo mkdir /home/thetaru/jupyter
```
```
$ sudo vi /home/thetaru/.jupyter/jupyter_notebook_config.py
```
```
c = get_config()

### 接続元IPの制限
c.NotebookApp.ip = '*'

### token passwordの設定(パスワードなしは非推奨)
c.NotebookApp.token = ''
c.NotebookApp.password = ''

### [Option] ディレクトリの指定(無効化する場合はコメントアウト)
c.NotebookApp.notebook_dir = '/home/thetaru/jupyter'

### ブラウザの立ち上げ
c.NotebookApp.open_browser = False

### Quitボタンを隠す
c.NotebookApp.quit_button = False

### ポート指定
c.NotebookApp.port = 8888
```
## Jupyter Notebookのデーモン化
Jupyter Notebookをユーザ`thetaru`で実行します。
```
$ sudo vi /etc/systemd/system/jupyter.service
```
```
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
WorkingDirectory=/home/thetaru
ExecStart=/bin/jupyter-notebook --config=/thetaru/.jupyter/jupyter_notebook_config.py

User=thetaru
Group=thetaru

[Install]
WantedBy=multi-user.target
```
```
### 設定を読み込んで起動
$ sudo systemctl daemon-reload
$ sudo systemctl start jupyter.service
```
```
### Activeであることを確認
$ sudo systemctl status jupyter.service
```
```
### 自動起動の設定
$ sudo systemctl enable jupyter.service
```
