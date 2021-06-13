# ネットワークプログラミングの基礎
## 15.1 インターネットの仕組み
常識的な内容なので省略

## 15.2 ホスト名とリゾルバ
常識的な内容なので省略

## 15.3 ソケットAPI
### ■ ソケット
Linuxでソケット通信に使うのがソケットです。  
ソケットとは、ストリームをそこに接続することができる口です。  
例えば、サーバ側とクライアント側の両方を扱えたり、使用するプロトコルもTCPとUDPの他、生のIPや、インターネット以外のネットワークプロトコルを使用することも可能です。  

### ■ クライアント側のソケットAPI
クライアント側からサーバにストリームを接続するには、次の2つのシステムコール呼び出しが必要です。
- socket(2)
- connect(2)

### ■ socket(2)
```c
#include <sys/socket.h>
#include <sys/types.h>

int socket(int domain, int type, int protocol);
```
|引数|意味|
|:---|:---|
|domain||
|type||
|protocol||

|戻り値|意味|
|:---|:---|
|成功|ファイルディスクリプタ(0以上の整数)|
|失敗|-1|

socket()は、ソケットを作成し、それに対応するファイルディスクリプタを返します。  
※ ファイルディスクリプタはストリーム以外にも対応することができることに注意しましょう。

### ■ connect(2)
```c
#include <sys/socket.h>
#include <sys/types.h>

int connect(int sock, const struct sockaddr *addr, socklen_t addrlen);
```
|引数|意味|
|:---|:---|
|sock|ソケット|
|addr|IPアドレス|
|addrlen|addrのサイズ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

### ■ サーバ側のソケットAPI
サーバ側(ストリームの接続を待つ側)は、次の4つのシステムコール呼び出しが必要です。
- socket(2)
- bind(2)
- listen(2)
- accept(2)

socket(2)については説明したので省略します。
### ■ bind(2)
```c
#include <sys/socket.h>
#include <sys/types.h>

int bind(int sock, struct sockaddr *addr, socklen_t addrlen);
```
|引数|意味|
|:---|:---|
|sock|ソケット|
|addr|IPアドレス|
|addrlen|addrのサイズ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

bind()は、接続を待つアドレスaddrをソケットsockに割り当てます。  

### ■ listen(2)
```c
#include <sys/socket.h>

int listen(int sock, int backlog);
```
|引数|意味|
|:---|:---|
|sock|ソケット|
|backlog|同時に受け付けるコネクションの最大値|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

listen()は、ソケットsockがサーバ用のソケット(接続を待つソケット)であることをカーネルに伝えます。

### ■ accept(2)
```c
#include <sys/socket.h>
#include <sys/types.h>

int accept(int sock, struct sockaddr *addr, socklen_t *addrlen);
```
|引数|意味|
|:---|:---|
|sock|ソケット|
|addr|IPアドレス|
|addrlen|addrのサイズ|

|戻り値|意味|
|:---|:---|
|成功|接続完了済みストリームのファイルディスクリプタ|
|失敗|-1|

accept()は、sockにクライアントが接続してくるのを待ち、接続が完了したら、接続完了済みストリームのファイルディスクリプタを返します。  
addrにはクライアントのアドレスが書き込まれます。  
addrlenには\*addrのサイズが書き込まれます。
