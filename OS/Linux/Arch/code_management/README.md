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
### (S)FTPによる自動アップデート
コマンドパレットより`SFTP: config`を実行すると、sftp.jsonファイルが開く。
> **Warning**  
> sftp.jsonファイルはプロジェクト毎に作成する。

#### SFTP
```json
{
	"name": "【リポジトリ名】",
	"protocol": "sftp",
	"host": "【リモートサーバのホスト名またはIPアドレス】",
	"port": 22,
	"username": "【リモートサーバのユーザ名】",
	"privateKeyPath": "【秘密鍵のパス】",
	"context": "【ローカルのアップロード元ディレクトリのパス】",
	"remotePath": "【リモートサーバのアップロード先ディレクトリのパス】",
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

#### FTP
```json
{
	"name": "【リポジトリ名】",
	"protocol": "ftp",
	"host": "【リモートサーバのホスト名またはIPアドレス】",
	"port": 21,
	"username": "【リモートサーバのユーザ名】",
	"password": "【リモートサーバのパスワード】",
	"context": "【ローカルのアップロード元ディレクトリのパス】",
	"remotePath": "【リモートサーバのアップロード先ディレクトリのパス】",
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
