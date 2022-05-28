# コード管理
## ■ 概念図

```mermaid
```

## ■ ディレクトリ構造
```
/
+-- thetaru/
    +-- Dropbox/
        +-- repositories/
            +-- project1/
                +-- ...
            +-- project2/
                +-- ...
```

## ■ VScodeの設定
### SFTPによる自動アップデート
コマンドパレットより`SFTP: config`を実行すると、sftp.jsonファイルが開く。
> **Warning**  
> sftp.jsonファイルはプロジェクト毎に作成する。

以下にように作成すること。
```json
{
	"name": "【リポジトリ名】",
	"protocol": "sftp",
	"host": "【リモートサーバのホスト名またはIPアドレス】",
	"port": 22,
	"username": "【リモートサーバのユーザ名】",
	"privateKeyPath": "【秘密鍵のパス】",
	"remotePath": "【リモートサーバのアップロード先のパス】",
	"ignore": [
		".vscode",
		".git"
	],
	"syncOption": {
		"delete": true,
		"skipCreate": false,
		"ignoreExisting": false,
		"update": false
	},
	"uploadOnSave": true,
	"watcher": {
		"files": "*",
		"autoUpload": true,
		"autoDelete": true
	}
}
```
