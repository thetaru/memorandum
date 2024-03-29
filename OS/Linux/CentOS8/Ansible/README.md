# Ansible
テンプレート作ったので[こちら](https://github.com/thetaru/ansible_template)を参考にしてください。
# § INSTALL
```
# yum -y install epel-release
# yum -y install ansible
```
```
### version確認
# ansible --version
```
```
ansible 2.9.11
```
# § COMMAND
## Syntax
```
# ansible-playbook [option] <inventory> <playbook>
```
|オプション|説明|
|:---|:---|
|-C, --check|チェックモードを有効にする。プレイブックの実行時に、実際に変更を適用しない|
|-D, --diff|変更内容の差分を表示する|
|-e, --extra-vars|エクストラ変数を指定する|
|-f, --forks|同じグループ内のホストに対して並列実行数(フォーク数)を指定する。(デフォルトでは5台)|
|**-i, --inventory**|**インベントリを指定する。通常、インベントリファイルを指定する**|
|-l, --limit|指定したホストもしくはグループに対してのみプレイブックを実行する|
|--syntax-check|プレイブックの文法チェックを実施する。プレイブックの実行はしない|
|-t, --tags|指定されたタグがついているタスクのみを実行する|
|-v, --verbose|詳細出力|
|**-k, --ask-pass**|**ターゲットノードに接続するユーザのパスワードを実行時に確認する**|
|-u, --user|ターゲットノードに接続するユーザ名を指定する|
|-c, --connection|プレイブック実行時に利用するコネクションプラグインを指定する|
|-T, --timeout|ターゲットノードから応答がなかった場合、何秒でタイムアウトするかを指定する(デフォルト:10秒)|
|-b, --become|権限昇格を有効にする|
|--become-method|権限昇格のメソッドを指定する|
|--become-user|権限昇格に利用するユーザを指定する|
|-K, --ask-become-pass|権限昇格時に利用するパスワードを指定する|
