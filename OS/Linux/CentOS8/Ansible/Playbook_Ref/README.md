# Ansible Playbook Module Reference
サードパーティ製は[ここ](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html)を参照するといいです。
## ■ 対象ホストの設定
```
- hosts: <value>
  tasls:
    - name: <task-name>
```
|パラメータ|説明|
|:---|:---|
|all|プレイブック実行時に指定したインベントリファイルに存在するすべてのホスト|
|localhost|Ansibleを実行しているノード自身|
|<ホスト名>|指定したホスト名|
|<ホストグループ>|指定したホストグループに所属するホスト|
## ■ ホスト名の変更
## Syntax
```
tasks:
  - name: <task-name>
    hostname:
      name: <hostname>
```
|パラメータ|説明|
|:---|:---|
|name|ホスト名を指定する|
## ■ パッケージのインストール
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
## ■ コンテンツの配置
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
## ■ サービスの起動
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
## ■ SELinuxの無効化
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
## ■ ターゲットノードの再起動
## Syntax
```
tasks:
  - name: <task-name>
    reboot:
    reboot_timeout: <sec>
```
|パラメータ|説明|
|:---|:---|
|connection_timeout|接続がタイムアウトするまでの最大の秒数を指定する|
|msg|再起動する前にログインしているユーザに指定したメッセージを表示する|
|pre_reboot_delay|再起動を実行する前に待機する秒数を指定する(デフォルト:0秒)|
|post_reboot_delay|再起動完了後に待機する秒数を指定する(デフォルト:0秒)|
|test_command|再起動後のターゲットホストでタスクの実行が可能かどうかを判断するためのコマンドを指定する(デフォルト:whoami)|
## ■ ターゲットノードが接続可能になるまで待機
## Syntax
```
tasks:
  -name: <task-name>
  wait_for_connection:
    timeout: <sec>
    connect_timeout: <sec>
    delay: <sec>
    sleep: <sec>
```
|パラメータ|説明|
|:---|:---|
|timeout|全体のタイムアウト時間を指定する|
|connection_timeout|接続可能か確認する際の試行時間を指定する|
|delay|接続確認を開始するまでの秒数を指定する|
|sleep|接続確認の試行から次の試行までの待ち時間を指定する|
## ■ ハンドラの設定
`notify`を組み込んだタスクに変更があった場合にのみ実行される処理を記述します。  
また、処理の実行タイミングはタスクセクション内のタスクがすべて実行された後です。
## Syntax
```
tasks:
  - name: <task-name>
  notify: <handler-name>
handlers:
  - name: <handler-name>
    <処理内容>
```
