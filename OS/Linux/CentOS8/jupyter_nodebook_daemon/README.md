# Jupyter Notebookをデーモンにする
## Jupyter Notebookのインストール
```
$ sudo apt install python3-pip python3-pandas
```
```
$ sudo apt install jupyter-notebook
```
## Jupyter Notebookの設定
```
$ sudo mkdir ~/.jupyter; touch ~/.jupyter/jupyter_notebook_config.py
```
```
$ sudo vi ~/.jupyter/jupyter_notebook_config.py
```
```
c = get_config()

# 全てのIPから接続を許可
c.NotebookApp.ip = '*'

#ブラウザは立ち上げない
c.NotebookApp.open_browser = False

# 特定のポートに指定(デフォルトは8888)
c.NotebookApp.port = 8888
```
