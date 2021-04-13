# sambaまとめ
## ■ プロセス
|プロセス|説明|
|:---|:---|
|smbd|ファイル共有、認証など|
|nmbd|ブラウジング機能、NetBIOS名前解決、WINSサーバなど|
|winbindd|Winbind機能|

## ■ ポート番号
|ポート番号|プロトコル|説明|
|:---|:---|:---|
|137|UDP|NetBIOS名前解決やブラウジング|
|138|UDP|NetBIOS名前解決やドメインログオン|
|139|TCP|ファイル共有|
|445|TCP|ファイル共有|

## ■ smb.conf
### globalセクション
|パラメータ|説明|
|:---|:---|
|workgroup|sambaサーバが所属するワークグループ名もしくはドメイン名を指定する。|
|server role|sambaサーバの動作モードを指定する。|
|netbios name|sambaサーバのNetBIOS名を指定する。|
|server string|サーバに関する説明を記述する。|
|hosts allow|接続を許可するホストを指定する。(指定外のホストは拒否される。)|
|guest account|アカウントが存在しないユーザにゲストとしてアクセスする場合に利用する。|
|map to guest|sambaユーザとして認証できなかった場合の動作を指定する</br>Never: ゲスト認証を許可しない</br>Bad User: 存在しないユーザを指定した場合、guest accountで定義されたユーザでログイン</br>|
|||
|||
|||
|||
