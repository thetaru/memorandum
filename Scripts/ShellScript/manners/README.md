# ShellScriptのお作法
## ■ 命名規則
### スクリプト名
`-`区切りの小文字英数字をつける。拡張子は`.sh`とする。
```
deploy-server.sh
```

### 変数名
- グローバル変数

`_`区切りの大文字英数字を使う。
```sh
GLOBAL_VAR="global"
```
- ローカル変数

`_`区切りの小文字英数字を使う。
```sh
local local_var="local"
```
### ループ変数
`_`区切りの小文字英数字を使う。
```sh
for rule in rules; do
  echo "${rule}"
done
```
指定回数分のループ処理の場合は`_`のみを使う。
```sh
for _ in $(seq 1 10); do
  echo "hoge"
done
```
※ python感がでてしまう

### 関数名
`_`区切りの小文字英数字を使う。
```sh
function func_name() {
  (snip)
}
```

## ■ 改行コード
LFを使用する。

## ■ Shebang
```sh
#!/bin/bash
```

## ■ bashオプション
```sh
set -euxo pipefail
```

## ■ ディレクトリ移動
### 実行場所がディレクトリに依存しない場合
スクリプトのあるディレクトリに移動する。
```sh
cd "$(dirname "$0")"
```

### 実行場所がディレクトリに依存する場合
カレントディレクトリを変数に保存後、スクリプトのあるディレクトリに移動する。
```sh
WORKDIR=$(pwd)
cd "$(dirname "$0")"
```

## ■ 変数
### 変数宣言
- 変数宣言時は必ず`""`あるいは`$()`で囲む
```sh
### 定数または変数を設定する場合は""で囲む
MESSAGE="Hello World!"

### コマンドの実行結果を設定する場合は$()で囲む
NOW=$(date)
```
### 変数展開
例外を除き`${}`で囲う。(例外は`$0`,`$1`,`$@`,`$?`などの特殊変数)
```sh
RESULT="success"
LOG_DIR="/var/log/hoge"
ARG="$1"
echo "Result is ${RESULT}" | tee "${LOG_DIR}/result.log"
```
## ■ 関数
### 関数定義
`function`をつけて定義する。
```sh
function 関数名() {
  処理
}
```
※ `function`を使わなくてもよいが、統一するため
### 変数宣言
関数内では変数宣言時に`local`をつけてローカル変数として扱うことができる。
## ■ 呼び出し
### 変数の呼び出し
- `${}`で囲む
```sh
diff "test-${DATE}-before" "test-${DATE}-after"
```
- `""`で囲む
```sh
diff "test-${DATE}-before" "test-${DATE}-after"
```
### コマンドの呼び出し
- `""`で囲む
```sh
chown "$(whoami)" /tmp/workdir
```
- 改行を入れる

80文字-120文字を越えるコマンドは改行`\`を入れる。
```sh
curl -X POST "${API_ENDPOINT}/users/${USER_ID}/status" \
  -F "status=I'm so happy" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" 
```
## ■ 制御構文
### if文
### while文
```sh
while read line; do
  処理
done < (入力生成)
```
テキストデータの読み込みやコマンド展開をする場合に使う。
```sh
while read line; do
  (snip)
done < $(find . -name '*.log')
```
### for文
```sh
for 変数 in 範囲; do
  処理
done
```
※ 範囲はglob(`*.txt`など)かbrace expansion(`{1..5}`など)  
## ■ エラーハンドリング
## ■ ロギング
## ■ オプション
うーん... いらんくない...?
## ■ 単体テスト
## ■ スクリプトのコード長
100行程度に収められないなら、ちゃんとしたプログラミング言語で書くべきだと思う。
## ■ Ref
- https://qiita.com/autotaker1984/items/bc758fcf368c1a167353
