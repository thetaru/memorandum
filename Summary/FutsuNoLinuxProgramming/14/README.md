# プロセスの環境
## 14.1 カレントディレクトリ
### ■ getcwd(3)
getcwd()は、プロセスのカレントワーキングディレクトリのパスを得る関数です。
```c
#include <unistd.h>

char *getcwd(char *buf, size_t bufsize);
```

|引数|意味|
|:---|:---|
|buf|バッファ|
|bufsize|パスのサイズ上限|

|戻り値|意味|
|:---|:---|
|成功|buf|
|失敗|NULL|

getcwd()は、自プロセスのカレントディレクトリをbufに書き込みます。

### ■ パスのためのバッファを確保する
getcwd()のbufsizeはどれくらいとればいいでしょうか?  
こういった場合には、malloc()を使ってバッファを確保し、とりあえず試してみる方法が使われます。  
具体的には、バッファの長さが足りないたびにrealloc()でバッファを増やすようにします。
```c
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#define INIT_BUFSIZE 1024

char* my_getcwd(void)
{
  char* buf;
  char* tmp;
  size_t size = INIT_BUFSIZE;
  buf = malloc(size);
  if (!buf) return NULL;
  for (;;) {
    errno = 0;
    if (getcwd(buf, size))
      return buf;
    if (errno != ERANGE) break;
    size *= 2;
    tmp = realloc(buf, size);
    if (!tmp) break;
    buf = tmp;
  }
  free(buf);
  return NULL;
}
```
### ■ chdir(2)
chdir()は、自プロセスのカレントディレクトリを変更できます。
```c
#include <unistd.h>

int chdir(const char *path);
```
|引数|意味|
|:---|:---|
|path|カレントディレクトリに指定するパス|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

### ■ 他のプロセスのカレントディレクトリ
APIで変更できるのは自プロセスのカレントディレクトリだけです。  
他のプロセスのカレントディレクトリを変更する方法はありません。

## 14.2 環境変数
環境変数とは、プロセスの親子関係を通じて伝播するグローバル変数のようなもの(PATHやLANGなど)です。  
プログラマが意識する環境変数はたいてい各コマンドのmanページの`ENVIRON`という節に記載されています。
### ■ environ
環境変数にはグローバル変数environを介してアクセスできます。  
型はchar\*\*なので、environの構造は次のようになります。  
※ 2次元配列?となっているため型がポインタのポインタとなっている。
```
  environ
     |
     v
+-----------+
|          -|---> "HOME=/home/test"
+-----------+
|          -|---> "EDITOR=vi"
+-----------+
|          -|---> "PAGER=less"
+-----------+
|          -|---> "HZ=100"
+-----------+
|          -|---> "DISPLAY=:0.0"
+-----------+
|          -|---> "LOGNAME=test"
+-----------+
|    NULL   |
+-----------+
```

例えば、自プロセスの環境変数をすべて表示してみます。
```c
#include <stdio.h>
#include <stdlib.h>

extern char **environ;

int main(int argc, char *argv[])
{
  char **p;
  
  for (p = environ; *p; p++) {
    printf("%s\n", *p);
  }
  exit(0);
}
```
environに直接アクセスする場合は、自分でextern宣言してくおく必要があります。  
なお、environの指す先は後述するputenv()で移動することがあるので、変数に保存して使ったりしてはいけません。

### ■ getenv(3)
```c
#include <stdlib.h>

char *getenv(const char *name);
```
|引数|意味|
|:---|:---|
|name|環境変数名|

|戻り値|意味|
|:---|:---|
|成功|環境変数の値|
|失敗|NULL|

getenv()は、環境変数名nameの値を検索して返します。  
getenv()の戻り値の文字列に書き込んではいけません。

### ■ putenv(3)
```c
#include <stdlib.h>

int putenv(char *string);
```
|引数|意味|
|:---|:---|
|string|「名前=値」の形式の文字列|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

putenv()は、環境変数の値をセットします。  
引数のstringは、`名前=値`の形式でなければなりません。  
なお、putenv()は渡したstringをそのまま使い続けるので、stringの領域は静的に確保しておくかmalloc()で割り当てる必要があります。

## 14.3 クレデンシャルの操作
### ■ set-uid プログラム
#### set-uidプログラムとは
何らかの理由で、コマンドを実行するユーザに関係なく特定のユーザ権限で実行したいということがあります。(例えば、passwdコマンド)  
常に特定の権限で実行したいプログラムに**ファイルパーミッションのset-uidビット**をセットすると、起動したユーザに関係なくプログラムファイルのオーナー権限で起動されます。  
  
例えば、passwdコマンドを`ls -l`コマンドで見てみます。
```
$ ls -l /usr/bin/passwd
-rwsr-xr-x. 1 root root 33600  4月  7  2020 /usr/bin/passwd
```
オーナーのパーミッションを見ると、`rws`となっています、この`s`がset-uidビットが立っている印です。  
passwdファイルのオーナーはrootなので、passwdコマンドは誰が起動してもrootの権限で起動されるということになります。  
  
このようなプログラムを一般にset-uidプログラムといいます。

#### set-uidプログラムのユーザについて
set-uidプログラムから起動されたプロセスには、2種類のクレデンシャル(プロセスを起動したユーザと、set-uidプログラムのオーナー)が存在します。  
このとき、起動したユーザのID(ユーザのUID)を実ユーザID、set-uidプログラムのオーナーのID(オーナーのUID)のほうを実効ユーザIDといいます。  

#### set-uidプログラムのグループについて
ユーザだけでなくグループにも同様の自動昇格の仕組みがあります。  
それを指示するパーミッションフラグのことをset-gidビット、起動したユーザのグループIDを実グループID、set-gidプログラムの所有グループのIDを実効グループIDといいます。

### ■ 現在のクレデンシャルを得る
まずは現在のクレデンシャルを得るシステムコールを説明します。
#### getuid(2)、geteuid(2)、getgid(2)、getegid(2)
```c
#include <unistd.h>
#include <sys/types.h>

uid_t getuid(void);
uid_t geteuid(void);
gid_t getgid(void);
git_t getegid(void);
```
getuid()は、自プロセスの実ユーザIDを返します。  
geteuid()は、自プロセスの実効ユーザIDを返します。  
getgid()は、自プロセスの実グループIDを返します。  
getegid()は、自プロセスの実効グループIDを返します。  
以上、4つのシステムコールは失敗しません。  

#### getgroups(2)
```c
#include <unistd.h>
#include <sys/types.h>

int getgroups(int bufsize, gid_t *buf);
```
|引数|意味|
|:---|:---|
|bufsize|保持できる補足グループIDの最大値|
|buf|バッファ|

|戻り値|意味|
|:---|:---|
|成功|補足グループIDの数(0以上)|
|失敗|-1|

getgroup()は、自プロセスの補足グループIDをbufに書き込みます。  
ただし、プロセスの補足グループIDがbufsize個より多い場合は、書き込まずエラーとなります。

### ■ 別のクレデンシャルに移行する
現在の権限を捨てて新しいクレデンシャルに移行するには、setuid()、setgid()、initgroups()の3つをセットで使います。

#### setuid(2)、setgid(2)
```c
#include <unistd.h>
#include <sys/types.h>

int setuid(uid_t id);
int setgid(gid_t id);
```
setuid()は、自プロセスの実ユーザIDと実効ユーザIDをidに変更します。
setgid()は、自プロセスのグループIDと実効グループIDをidに変更します。

#### initgroups(2)
```c
#define _BSD_SOURCE
#include <grp.h>
#include <sys/types.h>

int initgroups(const char *user, gid_t group);
```
