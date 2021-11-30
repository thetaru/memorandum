# SELinux
## ■ 機能の概要
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/SELinux/abstract)に記載しました。
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|selinux-autorelabel-mark.service|なし||
|selinux-autorelabel.service|なし||

## ■ 主設定ファイル /etc/selinux/config
### ● パラメータ
#### SELINUX
|設定値|説明|
|:---|:---|
|enforcing|SELinuxの機能を有効にする|
|permissive|SELinuxの機能を有効にするが機能制限はせず、監査ログのみ記録する(試験用)|
|disabled|SELinuxの機能を無効にする|

#### SELINUXTYPE
設定値|説明|
|:---|:---|
|targeted|代表的なデーモンが制御対象となる|
|strict|すべてのデーモンが制御対象となる|
|MLS|strict+RBACで動作する|

### ● 設定例
以下の設定だとSELinuxは有効となります。
```
SELINUX=enforcing
SELINUXTYPE=targeted
```

## ■ RBACの設定
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/SELinux/rbac)にまとめました。

## ■ 設定用コマンド
### ● セキュリティコンテキストの設定
#### ◆ ファイル/ディレクトリのタイプの確認
ファイルやディレクトリに対応している、タイプとコンテキストを確認できます。
```
# semanage fcontext -l
```
#### ◆ ファイル/ディレクトリのタイプの変更
```
# semanage fcontext -a -t <タイプ> <対象のファイル>
```
※1 ファイルは絶対パスで指定すること  
※2 内容は`/etc/selinux/targeted/contexts/files/file_contexts.local`に保存されます

```
# restorecon -v <対象のファイル>
```
※ ファイルは絶対パスで指定すること

#### ◆ ファイル/ディレクトリのタイプの削除
追加されたタイプを削除します。
```
# semanage fcontext -d <対象のファイル>
```
※ ファイルは絶対パスで指定すること  

```
# restorecon -v[F] <対象のファイル>
```
※ ファイルは絶対パスで指定すること  
※ Fオプションはコンテキストを強制的にリセットし、ユーザ・ロール・タイプを変更します(実質、SELinuxをdisable->Enforcingした際の挙動に等しい)  
※ Rオプションは対象をディレクトリとしてときに有効で、再帰的にrestoreconを実行します

#### ◆ タイプのチェック
ファイルのタイプからファイルのロケーションがマッチしているかなどをチェックします。
```
# matchpathcon -V <対象のファイル>
```
※ ワイルドカードを使った指定もできます

### ● マッピングの設定
#### ◆ SELinuxユーザの確認
```
# semanage login -l
```
#### ◆ LinuxユーザとSELinuxユーザをマッピング
```
# semanage login -a -s <SELinuxユーザ> <Linuxユーザ>
```
#### ◆ マッピングの削除
```
# semanage login -d <Linuxユーザ>
```

### ● 通信ポートの設定
#### ◆ SELinuxポートタイプの確認
SELinuxポートタイプと対応している、プロトコルとポート番号を確認できます。
```
# semanage port -l
```
#### ◆ SELinuxポートタイプにルールを追加
```
# semanage port -a -t <SELinuxポートタイプ> -p <プロトコル(tcp|udp)> <ポート番号>
```
※ すでにSELinuxポートタイプと紐付いているプロトコルとポート番号の組は追加できません
#### ◆ SELinuxポートタイプからルールを削除
```
# semanage port -d -t <SELinuxポートタイプ> -p <プロトコル(tcp|udp)> <ポート番号>
```

### ● ブール値の設定
#### ◆ ブール値の確認
```
# semanage boolean -l
```

#### ◆ ブール値の変更
```
# setsebool -P <ブール値> <on|off>
```

#### ◆ 変更したブール値の確認
```
# semanage boolean -l --locallist
```

### ● かんたんな対処方法
SELinuxが動作しているシステムで`/var/log/audit/audit.log`にdeniedログが出力されている場合、以下のコマンドでモジュールを追加することができます。  
この方法でルールを適用する場合、(`setenforce`コマンドで)一時的にSELinuxのステータスを`permissive`に変更して、ルールの洗い出しを行うべきです。
```
### 拒否されたルールの確認
# ausearch -m avc [-c <プロセス名>] | audit2allow

### 拒否されたルールを元にモジュールを作成し読み込み
# ausearch -m avc [-c <プロセス名>] | audit2allow -M <rule>
# semodule -i <rule>.pp

### モジュールの確認
# semodule -l
```
※ ちなみにモジュールの作成先は`/usr/share/selinux/targeted/default/active/modules/100/`のようです。  
モジュールを削除する場合は以下のとおりです。
```
### モジュールの確認
# semodule -l

### モジュールの削除
# semodule -r <モジュール名>
```
`permissive`にできない場合、複数の動作が拒否されていることがあるので、何度か上のコマンドを繰り返せばそれらのルールも追加できます。  
ただし、SELinuxが原因だが、audit.logに出力されない場合もあるので注意しましょう。  
`semodule -r`ではデフォルトで存在するモジュールは削除できない(プライオリティ的な問題だと思うのでいじれば削除可能だと思う...)  
モジュールのディレクトリを削除しても`semodule -l`には反映されない

## ■ 調査・確認用コマンド
### ● SELinuxユーザ
#### ◆ SELinuxユーザの確認
```
# semanage user -l
```
#### ◆ マッピング情報の確認
```
# semanage login -l
```

### ● ロール
#### ◆ 利用可能なロールを確認
```
# seinfo -r
```

#### ◆ SELinuxユーザに割り当てられるロールを確認
```
# cat /etc/selinux/targeted/contexts/users/<SELinuxユーザ>
```
### ● タイプ
#### ◆ タイプの確認
```
# seinfo -t -x
```
※ たくさん出力されるので注意

#### ◆ タイプ遷移の確認
```
# sesearch -T -s <遷移元ドメイン>
```
※ `type_transition <遷移元ドメイン> <遷移元タイプ>:<タイプのリソース> <遷移先タイプ> <リソース名>`の形式で出力されます  
遷移元ドメインのプロセスが遷移元タイプのディレクトリ(?)にアクセスするとリソースのタイプは遷移先タイプとなります

#### ◆タイプ遷移可能性の確認
```
# sesearch -T -s <遷移元ドメイン> -t <遷移元タイプ>
```

### ● ドメイン
#### ◆ ドメインの確認
```
# seinfo -a domain -x
```

#### ◆ ドメイン遷移先の確認
```
# sepolicy transition -s <遷移元ドメイン>
```
※ `<遷移元ドメイン> @ <タイプ> --> <遷移先ドメイン>`の形式で出力されます

#### ◆ ドメイン遷移可能性の確認
```
# sepolicy transition -s <遷移元ドメイン> -t <遷移先ドメイン>
```

### ● ルール
#### ◆ ルールの確認
ドメインAからタイプBにアクセス可能なルールがあるか確認する。
```
# sesearch -A -s <ドメイン> -t <タイプ>
```
#### ◆ リソースを制限したルールの確認
```
# sesearch -A -s <ドメイン> -t <タイプ> -c <リソース>
```
※ リソースは、ファイル(file)やディレクトリ(dir)、プロセスなどの総称

### ● auditログ
#### ◆ すべてのauditログを出力
```
# ausearch -m avc
```

#### ◆ 期間制限をしたauditログを出力
```
# ausearch -m avc -ts <today|recent>
```
※ todayは今日のログでrecentは最新10分間のログです

#### ◆ プロセス指定をしたauditログを出力
```
# ausearch -m avc -c <プロセス名>
```
