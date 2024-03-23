# Python環境構築
## ■ ryeのインストール
執筆時のryeのバージョン情報は以下の通り。
|バージョン|プラットフォーム|
|:---:|:---:|
|0.31.0|linux(x86_64)|

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
> [!WARNING]
> プロジェクト名に`_`や`-`を入れた場合、`rye sync`を実行後、以下のエラーが出て同期が失敗した。(ryeのバージョンは、`0.1.0`)  
> Invalid script entry point: <ExportEntry hello = <プロジェクト名>:None []> - A callable suffix is required.
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
rye add isort
rye add python-dotenv
rye add email-validator
rye add flask-debugtoolbar
rye add flask-sqlalchemy==2.5.1
rye add flask-migrate
rye add sqlalchemy==1.4
rye add flask-wtf
rye add flask-login
rye add mypy --dev
rye add flake8 --dev
rye add black --dev
rye add pytest --dev
```
### パッケージの削除
`rye remove`コマンドを実行すると、`pyproject.toml`にパッケージ情報が削除される。
```sh
rye remove flask
```
### パッケージの表示
`rye list`コマンドを実行すると、プロジェクトにインストールされているすべての依存関係が表示される。
```sh
rye list
```
## ■ Ruffとの連携
Ruffは、Rust製のLinter/Formatterのこと。
### Ruffのインストール
`rye install`コマンドでグローバルにインストールすることができる。  
以下では、`rye add`コマンドでインストールしている。
```sh
rye add ruff --dev
```
### Ruffの設定
`pyproject.toml`に以下の設定を追記する。詳細は[公式](https://docs.astral.sh/ruff/settings/)を参照すること。 
<details>
<summary>Ruffの設定例</summary>

```toml
[tool.ruff]
# Exclude a variety of commonly ignored directories.
exclude = [
    ".bzr",
    ".direnv",
    ".eggs",
    ".git",
    ".git-rewrite",
    ".hg",
    ".ipynb_checkpoints",
    ".mypy_cache",
    ".nox",
    ".pants.d",
    ".pyenv",
    ".pytest_cache",
    ".pytype",
    ".ruff_cache",
    ".svn",
    ".tox",
    ".venv",
    ".vscode",
    "__pypackages__",
    "_build",
    "buck-out",
    "build",
    "dist",
    "node_modules",
    "site-packages",
    "venv",
]

# Same as Black.
line-length = 88
indent-width = 4

# Assume Python 3.8
target-version = "py38"

[tool.ruff.lint]
# Enable Pyflakes (`F`) and a subset of the pycodestyle (`E`)  codes by default.
# Unlike Flake8, Ruff doesn't enable pycodestyle warnings (`W`) or
# McCabe complexity (`C901`) by default.
select = ["E4", "E7", "E9", "F"]
ignore = []

# Allow fix for all enabled rules (when `--fix`) is provided.
fixable = ["ALL"]
unfixable = []

# Allow unused variables when underscore-prefixed.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

[tool.ruff.format]
# Like Black, use double quotes for strings.
quote-style = "double"

# Like Black, indent with spaces, rather than tabs.
indent-style = "space"

# Like Black, respect magic trailing commas.
skip-magic-trailing-comma = false

# Like Black, automatically detect the appropriate line ending.
line-ending = "auto"

# Enable auto-formatting of code examples in docstrings. Markdown,
# reStructuredText code/literal blocks and doctests are all supported.
#
# This is currently disabled by default, but it is planned for this
# to be opt-out in the future.
docstring-code-format = false

# Set the line length limit used when formatting code snippets in
# docstrings.
#
# This only has an effect when the `docstring-code-format` setting is
# enabled.
docstring-code-line-length = "dynamic"
```
</details>

### Formatterの実行
`rye fmt`コマンドを実行すると、`pyproject.toml`に記載した内容に沿ってコードがフォーマットされる。
```sh
rye fmt
```
`check`オプションを渡すことで、コードに変更がかかるかどうかを確認できる。
```sh
rye fmt --check
```
`diff`オプションを渡すことで、コードの変更前・変更後の差分を確認できる。
```sh
rye fmt -- --diff
```
### Linterの実行
`rye lint`コマンドを実行すると、`pyproject.toml`に記載した内容に沿ってコードのチェックがされる。
```sh
rye lint
```
`fix`オプションを渡すことで、自動修正が走る。
```sh
rye lint --fix
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
