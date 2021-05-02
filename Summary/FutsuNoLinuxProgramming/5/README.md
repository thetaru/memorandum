# ストリームにかかわるシステムコール
## 5.1 本章で話すこと
以下のシステムコールを使用してストリームを操作することで入出力を実現します。
- read
> ストリームからバイト列を読み込む
- write
> ストリームにバイト列を書き込む
- open
> ストリームを作る
- close
> 用済みのストリームを始末する
## 5.2 ファイルディスクリプタ
プロセスがファイルを読み書きしたり他のプロセスとやりとりするときにはストリームを使います。  
このストリームをプログラムから扱うには、ファイルディスクリプタというものを使います。
### ファイルディスクリプタとは?
プログラムから見たファイルディスクリプタはただの整数値(int型)です。  
カーネルの中には、実際にストリーム(を管理するデータ型)があるのですが、ストリームを直接プロセスに見せるわけにはいきません。  
そこで、カーネルが持っているストリームと番号(i.e. ファイルディスクリプタ)を対応させることで、プロセスは番号からストリームを指定できるようになります。  
  
以上のように、ストリームと番号(ファイルディスクリプタ)の対応関係が重要になってきます。
## 5.3 標準入力、標準出力、標準エラー出力
ストリームとファイルディスクリプタの対応関係を知るにはどうすればいいでしょうか。  
一番簡単なのは、プロセスの開始時から使えることがわかっている既知のファイルディスクリプタを使うことです。  
  
シェルからプロセスが起動された場合、どのプロセスも以下の3つのストリームが用意されており、それに対応するファイルディスクリプタも固定されています。
|ファイルディスクリプタ|マクロ|説明|
|:---|:---|:---|
|0|STDIN_FILENO|標準入力|
|1|STDOUT_FILENO|標準出力|
|2|STDERR_FILENO|標準エラー|

## 5.3.1 標準入力と標準出力
コマンドを一般的に標準入力からデータを読み込み、処理結果を標準出力へ書き込むようになっています。  
標準入力はプログラムの入力元で、標準出力はプログラムの出力先だということです。  
  
`cat`: キーボード入力された文字列をモニタに出力する例
```
                          cat
+----------+  stream  +---------+  stream  +---------+
| keyboard | -------> | process | -------> | monitor |
+----------+  STDIN   +---------+  STEDOUT +---------+

```
  
`cat file`: ファイル内容をモニタに出力する例
```
                          cat
+----------+  stream  +---------+  stream   +---------+
|   file   | -------> | process | --------> | monitor |
+----------+  STDIN   +---------+  STEDOUT  +---------+

```
ここですごいのは、catプロセスは自分がファイルからデータを読み込んでいることを知らないということです。  
というのも、ファイルとプロセス間のストリーム(ここでは標準入力のこと)はシェルが管理するのでプロセスは入力元について関知しません。  
※ ファイル-プロセス間のストリームのみに限る話ではありません。  
  
`grep print < hello.c | head`
```
                          grep                        head
+----------+  stream  +---------+   stream(pipe)   +---------+  stream   +---------+
|   file   | -------> | process | ---------------> | process | --------> | monitor |
+----------+  STDIN   +---------+  STEDOUT  STDIN  +---------+  STEDOUT  +---------+

```
## 5.3.2 標準エラー出力
エラーメッセージが標準出力に出てしまうと、ユーザがそのメッセージに気付かない可能性が高いです。  
そのため、端末に繋がっている可能性がより高いストリームを余分に用意して、プログラムに渡したい標準出力に、人間に読ませたい出力は標準エラー出力に出すようにします。

## 5.4 ストリームの読み書き
ファイルディスクリプタについて説明したので、システムコールについて説明します。
## 5.4.1 read(2)
ストリームからバイト列を読み込むには、read()というシステムコールを使います。
### Syntax - read
```c
#include <unistd.h>

ssize_t read(int fd, void *buf, size_t bufsize);
```
read()は、ファイルディスクリプタfd番のストリームからバイト列を読み込むシステムコールです。  
最大bufsizeバイト読み、bufに格納します。bufのサイズをそのままbufsizeに指定するのが一般的です。  
  
read()は、読み込みが問題なく完了したときは読み込んだバイト数を返します。  
ファイル終端に達したときは0を、エラーが起きたときは-1を返します。  
  
※ 文字列を扱うシステムコールを使用する場合は、NULL文字`/0`で終端が前提かどうかを確認しましょう。
## 5.4.2 write(2)
ストリームにバイト列を書き込むには、write()というシステムコールを使います。
### Syntax - write
```c
#include <unistd.h>

ssize_t write(int fd, const void *buf, size_t bufsize);
```
write()は、bufsizeバイト分をbufからファイルディスクリプタfd番のストリームに書き込みます。  
  
write()は、正常に書き込んだときは書いたバイト数を返します。エラーが起きたときは-1を返します。  

## 5.4.3 ストリームの定義
ストリームは、ファイルディスクリプタで表現され、read()またはwrite()を呼べるもののことです。
## 5.5 ファイルを開く
## 5.5.1 open(2)
ファイルに接続するストリームを用意するためには、システムコールopen()を使います。
### Syntax - open
```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int open(const char *path, int flags);
int open(const char *path, int flags, mode_t mode);
```
open()は、パスpathで表されるファイルにつながるストリームを作成し、そのストリームを指すファイルディスクリプタを返します。  
第2引数のflagsはストリームの性質を表すフラグです。
|フラグ|意味|
|:---|:---|
|O_RDONLY|読み込み専用|
|O_WRONLY|書き込み専用|
|O_RDWR|読み書き両用|
|O_CREAT|ファイルが存在しなければ新しいファイルを作る|
|O_EXCL|O_CREATとともに指定すると、すでにファイルが存在するときはエラーになる|
|O_TRUNC|O_CREATとともに指定すると、ファイルが存在するときはまずファイルの長さをゼロにする|
|O_APPEND|write()が常にファイル末尾に書き込むよう指定する|

第3引数のmodeは、flagsにO_CREATを指定したときのみ有効な引数です。  
ファイルを新しく作る場合に、そのファイルのパーミッションを指定します。
## 5.5.2 close(2)
ストリームを始末するシステムコールです。使い終わったストリームをclose()を使って始末します。
### Syntax - close
```c
#include <unistd.h>

int close(int fd);
```
close()は、ファイルディスクリプタfdに関連付けられたストリームを始末します。  
問題なくストリームを閉じられたら0を返し、エラーが起きた場合は-1を返します。
## 5.6 catコマンドを作る
## 5.6.1 cat.c
オプションなしのcatコマンドを再現してみます。
```c
### FileName: cat.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

static void do_cat(const char *path);
static void die(const char *s);

int main(int argc, char *argv[])
{
    int i;
    if (argc < 2) {
        fprintf(stderr, "%s: file name not given\n", argv[0]);
        exit(1);
    }
    for (i = 1; i < argc; i++) {
        do_cat(argv[i]);
    }
    exit(0);
}

#define BUFFER_SIZE 2048

static void do_cat(const char *path)
{
    int fd;
    unsigned char buf[BUFFER_SIZE];
    int n;
    
    fd = open(path, O_RDONLY);
    if (fd < 0) die(path);
    for (;;) {
        n = read(fd, buf, sizeof buf);
        if (n < 0) die(path);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) die(path);
    }
    if (close(fd) < 0) die(path);
}

static void die(const char*s)
{
    perror(s);
    exit(1);
}
```
## 5.6.2 main()
```c
int main(int argc, char *argv[])
{
    int i;
    if (argc < 2) {
        fprintf(stderr, "%s: file name not given\n", argv[0]);
        exit(1);
    }
    for (i = 1; i < argc; i++) {
        do_cat(argv[i]);
    }
    exit(0);
}
```
コマンドライン引数に渡された引数の数(配列argvの長さ)をチェックしています。(1つも渡されていなかったらエラーとなります。)  
※ argv[0]はプログラム名が入ることに注意します。
## 5.6.3 do_cat() その1
do_cat()の全体像です。
```c
#define BUFFER_SIZE 2048

static void do_cat(const char *path)
{
    int fd;
    unsigned char buf[BUFFER_SIZE];
    int n;
   
    fd = open(path, O_RDONLY);
    if (fd < 0) die(path);
    for (;;) {
        n = read(fd, buf, sizeof buf);
        if (n < 0) die(path);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) die(path);
    }
    
    if (close(fd) < 0) die(path);
}
```
## 5.6.4 do_cat() その2
まず見るのは、open()とclose()のペアです。
```c
    fd = open(path, O_RDONLY);
    if (fd < 0) die(path);
    ...
    if (close(fd) < 0) die(path);
```
open()でファイルを開いています。フラグの引数がO_RDONLYなので読み込み専用で開いていることがわかります。  
次の行で、正常にファイルが開けていることを確認しています。
最後に、ファイルを使い終わったのでclose()でファイルを閉じています。(close()はエラー時に-1を返すためif文の中に入れています。)
## 5.6.5 do_cat() その3
```c
    for (;;) {
        n = read(fd, buf, sizeof buf);
        if (n < 0) die(path);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) die(path);
    }
```
ファイルを読み込んでいます。  
読み込みエラー(n<0)かファイル終端までいった(n==0)か書き込みエラー(write(STDOUT_FILENO, buf, n) < 0)になるまで無限ループします。
## 5.6.6 do_cat() その4
```c
        n = read(fd, buf, sizeof buf);
        if (n < 0) die(path);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) die(path);
```
read()によって、ファイルディスクリプタfdが示すストリームからbufにバイト列を読み込みます。  
読み込むサイズは最大でも配列bufのサイズ(`sizeof buf`)までです。 
  
write()でバッファbufの内容を標準出力(STDOUT_FILENO)に書き込みます。  
バッファ全体を書き込むのではなく、nバイト(read()で読み込んだバイト数)だけ書き込みます。
  
残りはエラー処理で上で説明した通りです。
## 5.6.7 errno変数
システムコールが失敗したときは、失敗した原因を表す定数がグローバル変数errnoにセットされます。
## 5.6.8 die()
エラーが発生し、原因が判明したらその原因に従って何らかの処理をする必要があります。  
今回は、exit()するだけで対処しています。
```c
static void die(const char*s)
{
    perror(s);
    exit(1);
}
```
perror()でエラーメッセージを出力し、exit()で終了するだけの関数です。
## 5.6.9 peeror(3)
### Syntax - perror
```c
#include <stdio.h>

void perror(const char *s);
```
errnoの値に合わせたエラーメッセージを標準エラー出力に出力します。  
文字列sがNULLでも空文字でもないときはsと":"を出力し、そのあとにメッセージを出力します。
## 5.7 その他のシステムコール
## 5.7.1 ファイルオフセット
ストリームはファイルとつながっているとだけ説明しましたが、ここからは更に詳細に説明します。  
同じディスクリプタに対して複数回read()システムコールを呼ぶと、必ず前回の続きが返ってきます。  
つまり、ストリームにはファイルをどこまで読み込んだか(オフセット)を記憶しているはずです。
```
File
                  stream
                     v
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
|     |     |     |     |     |     |     |     |     |     |
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
<----------------->
       offset
```
このストリームがつながっている位置のことをファイルオフセットといいます。  
ファイルオフセットはストリームの属性で、システムコールを使って操作できます。
## 5.7.2 lseek(2)
ファイルオフセットを操作できるシステムコールです。  
### Syntax - lseek
```c
#include <sys/types.h>
#include <unistd.h>

off_t lseek(int fd, off_t offset, int whence);
```
lseek()は、ファイルディスクリプタfd内部のファイルオフセットを指定した位置offsetに移動します。  
位置の指定方法は3通りあり、whenceで指定できます。
|フラグ|移動先|起点|
|:---|:---|:---|
|SEEK_SET|offsetに移動|ファイル先頭|
|SEEK_CUR|現在のファイルオフセット+offsetに移動|現在のファイルオフセット|
|SEEK_END|ファイル末尾+offsetに移動|ファイル末尾|

## 5.7.3 dup(2), dup2(2)
### Syntax - dup, dup2
```c
#include <unistd.h>

int dup(int oldfd);
int dup2(int oldfd, int newfd);
```
dup()とdup2()は、ファイルディスクリプタoldfdを複製するシステムコールです。  
dup()とdup2()はプロセスにかかわるシステムコールと一緒に使うことが多いので、12章で改めて説明します。
## 5.7.4 ioctl(2)
### Syntax - ioctl
```c
#include <sys/ioctl.h>

int ioctl(int fd, int request, ...);
```
ioctl()は、ストリームがつながる先にあるデバイスに特化した操作をすべて含めたシステムコールです。  
例えば、次のような操作を行えます。
- CD-ROMドライブのトレイの開閉、音楽CDの再生
- プリンタの駆動や一時停止
- SCSIデバイスのハードウェアオプションのセット
- 端末の通信速度の設定

第2引数のrequestにどのような操作をするかを定数で指定し、そのrequest特有の引数を第3引数以降に渡します。
## 5.7.5 fcntl(2)
特殊な操作はioctl()だけで行いましたが、その中からファイルディスクリプタ関連の操作を分離したのがfcntl()です。
### Syntax - fcntl
```c
#include <unistd.h>
#include <fcntl.h>

int fcntl(int fd, int cmd, ...);
```
第2引数のcmdによって実際に行う操作を指定するようになっており、cmdの種類によって第3引数以降の使い方が決定します。
## 5.8 練習問題
### 1
引数の個数で場合分けして、readで標準入力(STDIN_FILENO)から受け取るようにするだけです。

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

static void do_cat(const char *path);
static void do_dup();
static void die(const char *s);

int main(int argc, char *argv[])
{
    int i;
    if (argc < 2) {
        do_dup();
    }
    for (i = 1; i < argc; i++) {
        do_cat(argv[i]);
    }
    exit(0);
}

#define BUFFER_SIZE 2048

static void do_cat(const char *path)
{
    int fd;
    unsigned char buf[BUFFER_SIZE];
    int n;
    
    fd = open(path, O_RDONLY);
    if (fd < 0) die(path);
    for (;;) {
        n = read(fd, buf, sizeof buf);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) die(path);
    }
    if (close(fd) < 0) die(path);
}

static void do_dup()
{
    unsigned char buf[BUFFER_SIZE];
    int n;

    for (;;) {
        n = read(STDIN_FILENO, buf, sizeof buf);
        if (n == 0) break;
        if (write(STDOUT_FILENO, buf, n) < 0) exit(1);
    }
}

static void die(const char*s)
{
    perror(s);
    exit(1);
}
```
