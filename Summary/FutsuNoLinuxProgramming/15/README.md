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
|sock|ソケットを示すファイルディスクリプタ|
|addr|ソケットに割り当てるアドレス|
|addrlen|addrの指す構造体のサイズ|

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
|sock|ソケットを示すファイルディスクリプタ|
|backlog|同時に受け付けるコネクションの最大値(保留中のキューの最大長)|

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
|sock|ソケットを示すファイルディスクリプタ|
|addr|接続した相手のIPアドレスやポート番号などの情報を含む|
|addrlen|addrの指す構造体のサイズ|

|戻り値|意味|
|:---|:---|
|成功|接続完了済みストリームのファイルディスクリプタ|
|失敗|-1|

accept()は、sockにクライアントが接続してくるのを待ち、接続が完了したら、接続完了済みストリームのファイルディスクリプタを返します。  

## 15.4 名前解決
getaddrinfo()は正引き、getnameinfo()は逆引きができます。
### ■ getaddrinfo(3)
```c
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>

int getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
void freeaddrinfo(struct addrinfo *res);
char *gai_strerro(int err);

struct addrinfo {
  int             ai_flags;
  int             ai_family;
  int             ai_socktype;
  int             ai_protocol;
  socklen_t       ai_addrlen;
  struct sockaddr *ai_addr;
  char            *ai_canonname;
  struct addrinfo *ai_next;
```
|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|エラーの種類を示す0以外の値|

getaddrinfo()は、接続対象nodeのアドレスの候補をresに書き込みます。  
必要な情報を限定したいときはserviceとhistsで絞り込みます。  
resに書き込まれるのはstruct addrinfoのリンクリストです。
```
*res ----> +-----------+   +--> +-----------+   +--> +-----------+   +--> NULL
           |           |   |    |           |   |    |           |   |    
           |  ai_next  | --+    |  ai_next  | --+    |  ai_next  | --+    
           +-----------+        +-----------+        +-----------+
```
また、このstruct addrinfoのメモリ領域はmalloc()で割り当てられているので、明示的に開放する必要があります。  
そのために使うAPIがfreeaddrinfo()です。

## 15.5 daytimeクライアントを作る
実際にソケット周りのAPIを使ってみます。  
本節では、ソケットに接続すると現在時刻を返すサーバプログラムを作成します。

### ■ daytime.c
:warning: daytimeサービスはxinetd時代の代物なので準備する必要があります。  
また、`/etc/services`でchronyに対応させようとしたがchrony側はUDPでListenしていたのでダメでした。
```c
/* daytime.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

static int open_connection(char *host, char *service);

int
main(int argc, char *argv[])
{
    int sock;
    FILE *f;
    char buf[1024];

    sock = open_connection((argc>1 ? argv[1] : "localhost"), "chrony");
    f = fdopen(sock, "r");
    if (!f) {
        perror("fdopen(3)");
        exit(1);
    }
    fgets(buf, sizeof buf, f);
    fclose(f);
    fputs(buf, stdout);
    exit(0);
}

static int
open_connection(char *host, char *service)
{
    int sock;
    struct addrinfo hints, *res, *ai;
    int err;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    if ((err = getaddrinfo(host, service, &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo(3): %s\n", gai_strerror(err));
        exit(1);
    }
    for (ai = res; ai; ai = ai->ai_next) {
        sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
        if (sock < 0) {
            continue;
        }
        if (connect(sock, ai->ai_addr, ai->ai_addrlen) < 0) {
            close(sock);
            continue;
        }
        /* success */
        freeaddrinfo(res);
        return sock;
    }
    fprintf(stderr, "socket(2)/connect(2) failed");
    freeaddrinfo(res);
    exit(1);
}
```
