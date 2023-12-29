# Python環境構築
## ■ ryeのインストール
公式ドキュメント(`https://rye-up.com/guide/installation`)にしたがってインストールする。
```sh
curl -sSf https://rye-up.com/get | bash
```
ryeのPATHを通す。
```sh
echo 'source "$HOME/.rye/env"' >> ~/.bashrc
```
## ■ プロジェクトの作成
新規ディレクトリを作成し、プロジェクトを作成する。
```sh
rye init flaskbook
cd flaskbook
```
## ■ プロジェクトの同期
以下のコマンドを実行することで、プロジェクトの変更を反映することができる。  
`rye sync`コマンドを実行したタイミングでPythonやパッケージのインストールが開始する。  
以後、パッケージを追加・削除を行うたびに`rye sync`コマンドを実行する。  
```sh
rye sync
```
## ■ Pythonバージョンの指定
プロジェクトで使用するPythonバージョンを指定する。
```sh
rye pin 3.9.7
```
`.python-version`ファイルにバージョン情報が保存されている。
## ■ 依存関係の管理
### パッケージの追加
`rye add`コマンドを実行すると、`pyproject.toml`にパッケージ情報を追加される。
```sh
rye add flask==2.0.2
rye add Werkzeug==2.0.2
rye add flake8
rye add black
rye add isort
rye add mypy
rye add python-dotenv
rye add email-validator
rye add flask-debugtoolbar
rye add flask-sqlalchemy==2.5.1
rye add flask-migrate
rye add sqlalchemy==1.4
rye add flask-wtf
rye add flask-login
```
### パッケージの削除
`rye remove`コマンドを実行すると、`pyproject.toml`にパッケージ情報が削除される。
```sh
rye remove flask
```
## ■ 仮想環境
### 仮想環境の有効化
仮想環境を有効化するには、以下のコマンドを実行する。
```sh
source .venv/bin/activate
```
### 仮想環境の無効化
仮想環境を無効化するには、以下のコマンドを実行する。
```sh
deactivate
```
