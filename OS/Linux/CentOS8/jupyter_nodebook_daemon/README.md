# Jupyter Notebookをデーモンにする
## Jupyter Notebookのインストール
```
$ sudo apt install python3-pip python3-pandas
```
```
$ sudo apt install jupyter-notebook
```
## Jupyter Notebookの設定
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
$ sudo systemctl daemon-reload
$ sudo systemctl start jupyter.service
```
```
$ sudo systemctl status jupyter.service
```
```
$ sudo systemctl enable jupyter.service
```
