# Python環境構築(uv)
## ■ uvのインストール
執筆時のuvのバージョン情報は以下の通り。
|バージョン|プラットフォーム|
|:---:|:---:|
|0.52.0|linux(x86_64)|

公式ドキュメント(`https://docs.astral.sh/uv/getting-started/`)にしたがってインストールする。
```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```
デフォルトのインストール先ディレクトリは、`/home/<user>/.local/bin`なのでPATHは通しておくこと。

## ■ プロジェクトの作成
新規ディレクトリを作成し、プロジェクトを作成する。(以下では、exampleというディレクトリができる)
```sh
uv init example
cd example
```

## ■ Pythonバージョンの指定
プロジェクトで使用するPythonバージョンを指定する。
```sh
uv python pin 3.12
```
`.python-version`ファイルにバージョン情報が保存されている。

## ■ 依存関係の管理
### パッケージの追加
`uv add`コマンドを実行すると、パッケージがインストールされ`pyproject.toml`にパッケージ情報が追加される。  
開発時のみに使用するパッケージは、`--dev`オプションをつけてインストールする。
```sh
# Example
uv add flask
uv add pytest --dev
```
### パッケージの削除
`uv remove`コマンドを実行すると、パッケージがアンインストールされ`pyproject.toml`にパッケージ情報が削除される。  
開発時のみに使用するパッケージは、`--dev`オプションをつけてアンインストールする。
```sh
# Example
uv remove flask
uv remove pytest --dev
```
### パッケージの表示
`uv pip list`コマンドを実行すると、インストールされているすべての依存関係が表示される。
```sh
uv pip list
```
## パッケージの同期
以下のコマンドを実行することで、`pyproject.toml`を参照しパッケージをインストールできる。
```sh
uv sync
```
## requirements.txtの取り込み
`requirements.txt`を使って、パッケージをインストールする。
```sh
uv add -r requirements.txt
```
## requirements.txtへの吐き出し
`requirements.txt`へパッケージ情報を出力する。
```sh
uv pip freeze > requirements.txt
```

## ■ Ruffとの連携
Ruffは、Rust製のLinter/Formatterのこと。
### Ruffのインストール
`uv tool install`コマンドでグローバルにインストールすることができる。
```sh
uv tool install ruff
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
