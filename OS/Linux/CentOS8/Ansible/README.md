# Ansible
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
# § PLAYBOOKS
# ■ ホスト名の変更
## Syntax
```
tasks:
  - name: <task-name>
    hostname:
      name: <hostname>
```
|パラメータ|説明|
|:---|:---|
|name|コピー元となるコントロールノード上のファイルパスを指定する|
# ■ パッケージのインストール
## Syntax
```
tasks:
  - name: <task-name>
    yum:
      name: <package>
      state: <status>
```
|パラメータ|説明|
|:---|:---|
|name|パッケージを指定する|
|state|指定したパッケージの状態を定義する|
|enablerepo|(option)このタスクの間だけ有効化するリポジトリを指定する|
# ■ コンテンツの配置
## Syntax
```
tasks:
  - name: <task-name>
    copy:
      src: <src-path>
      dest: <dest-path>
      owner: <owner-user>
```
|パラメータ|説明|
|:---|:---|
|src|コピー元となるコントロールノード上のファイルパスを指定する|
|dest|コピー先となるターゲットノード上のファイルパスを指定する|
|owner|コピーされたファイルのオーナーを指定する|
|group|コピーされたファイルのグループを指定する|
|mode|コピーされたファイルのパーミッションを指定する|
# ■ サービスの起動
## Syntax
```
tasks:
  - name: <task-name>
    systemd:
      state:
      name:
```
|パラメータ|説明|
|:---|:---|
|name|対象とするサービスを指定する|
|state|対象サービスの状態を指定する [ started \| stopped \| restarted \| reloaded ]|
|enabled|対象サービスの自動起動の可否を指定する [ yes \| no ]|
|daeon_reload|対象サービスの操作前に、サービスの設定ファイルを再読み込みさせる|
# ■ SELinuxの無効化
## Syntax
```
tasks:
  - name: <task-name>
    selinux:
      state: <status>
```
|パラメータ|説明|
|:---|:---|
|policy|SELinuxのポリシーを指定する|
|state|SELinuxのステータスを指定する [ disabled \| permissive \| enforcing ]|
# ■ ターゲットノードの再起動
## Syntax
```
tasks:
  - name: <task-name>
    reboot:
    reboot_timeout: <num-of-sec>
```
|パラメータ|説明|
|:---|:---|
|connection_timeout|接続がタイムアウトするまでの最大の秒数を指定する|
|msg|再起動する前にログインしているユーザに指定したメッセージを表示する|
|pre_reboot_delay|再起動を実行する前に待機する秒数を指定する(デフォルト:0秒)|
|post_reboot_delay|再起動完了後に待機する秒数を指定する(デフォルト:0秒)|
|test_command|再起動後のターゲットホストでタスクの実行が可能かどうかを判断するためのコマンドを指定する(デフォルト:whoami)|
# ■ ハンドラの設定
`notify`を組み込んだタスクに変更があった場合にのみ実行される処理を記述します。  
また、処理の実行タイミングはタスクセクション内のタスクがすべて実行された後です。
## Syntax
```
tasks:
  - name: <task-name2>
  notify: <handler-name>
handlers:
  - name: <handler-name>
    <処理内容>
```
# § やりたいこと
playbook作り  
テンプレートとなるplaybookをまず作る。  
それをもとにして各種ミドルが乗ったplaybookを作って展開する。  
AWSも自動構築できるようにしたい

tipsとか
ロールの分割、ansible実行につかう変数はすべてhostsに押し込めてしますとか
きれいな構成を作れるようにするための豆知識が欲しいところ
