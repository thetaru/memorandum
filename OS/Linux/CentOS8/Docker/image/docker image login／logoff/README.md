# Docker Hubへのログイン/ログアウト
## Syntax
```
# docker login [option] [サーバ名]
```
|オプション|意味|
|:---|:---|
|--password, -p|パスワード|
|--username, -u|ユーザ名|
```
# docker logout [サーバ名]
```
### e.g.
#### Docker Hubへログイン
```
# docker login
```
```
USERNAME: 登録したユーザ名
PASSWORD: 登録したパスワード
Login Succeeded
```
#### Docker Hubからログアウト
```
# docker logout
```
```
Removing login credentials for https://index.docker.io/v1/
```
