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
このとき、起動したユーザのID(ユーザのUID)を実ユーザID、set-uidプログラムのオーナーのID(オーナーのUID)を実効ユーザIDといいます。  

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
|引数|意味|
|:---|:---|
|user|ユーザ|
|group|グループ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

initgroups()は、/etc/groupなどのデータベースを見て、ユーザuserの補足グループを自プロセスに設定します。  
また、グループgroupはユーザのグループ(primary group)を補足グループに追加するために使います。  
なお、initgroups()はスーパーユーザでないと成功しません。

#### 別ユーザになる手順
1. スーパーユーザ(root)として起動する(起動してもらう)
2. なりたいユーザのユーザ名とユーザID、グループIDを取得する
3. setgid(target_gid);
4. initgroups(target_username, target_gid);
5. setuid(target_uid);

initgroups()は、スーパーユーザで実行する必要があるので、setuid()は必ず最後に実行する必要があります。

## 14.4 ユーザとグループ
クレデンシャルとはプロセスの属性であり、その管理はカーネルです。  
一方、ユーザ・グループについての情報はカーネルがかかわっていません。
### ■ getpwuid(3)、getpwnam(3)
ユーザ情報を検索するAPIを紹介します。
```c
#include <pwd.h>
#include <sys/types.h>

struct passwd *getpwuid(uid_t id);
struct passwd *getpwnam(const char *name);

struct passwd {
  char *pw_name;    /* ユーザ名 */
  char *pw_passwd;  /* パスワード */
  uid_t pw_uid;     /* ユーザID */
  gid_t pw_gid;     /* グループID */
  char *pw_gecos;   /* 本名 */
  char *pw_dir;     /* ホームディレクトリ */
  char *pw_shell;   /* シェル */
};
```
#### getpwuid(3)
|引数|意味|
|:---|:---|
|id|ユーザID(UID)|

|戻り値|意味|
|:---|:---|
|成功|ユーザ情報をstruct passwd形式で返す|
|失敗|NULL|

getpwid()は、ユーザ情報をユーザIDから検索します。

#### getpwnam(3)
|引数|意味|
|:---|:---|
|name|ユーザ名|

|戻り値|意味|
|:---|:---|
|成功|ユーザ情報をstruct passwd形式で返す|
|失敗|NULL|

getpwnam()は、ユーザ情報をユーザ名から検索します。

### ■ getgruid(3)、getgrnname(3)
```c
#include <grp.h>
#include <sys/types.h>

struct group *getgrgid(gid_t id);
struct group *getgrnam(const char *name);

struct group {
  char *gr_name;      /* グループ名 */
  char *gr_passwd;    /* グループのパスワード */
  gid_t gr_gid;       /* グループID */
  char **gr_mem;      /* グループのメンバ(ユーザ名のリスト) */
};
```
#### getgruid(3)
|引数|意味|
|:---|:---|
|id|ユーザID(UID)|

|戻り値|意味|
|:---|:---|
|成功|グループ情報をstruct group形式で返す|
|失敗|NULL|

getgruid()は、グループ情報をグループIDから検索します。

#### getgrname(3)
|引数|意味|
|:---|:---|
|name|ユーザ名|

|戻り値|意味|
|:---|:---|
|成功|グループ情報をstruct group形式で返す|
|失敗|NULL|

getgrname()は、グループ情報をグループ名から検索します。

## 14.5 プロセスの使うリソース
プロセスが動作するにはいろいろなリソース(CPU、メモリ、バスなど)が必要です。  
カーネルは、各プロセスが使用するリソース量を都度記録しています。
### ■ getrusage(2)
getrusage()を使うと、様々なリソース使用量が得られます。
```c
#include <unistd.h>
#include <sys/resource.h>
#include <sys/time.h>

int getrusage(int who, struct rusage *usage);
```
|引数|意味|
|:---|:---|
|who|RUSAGE_SELFまたはRUSAGE_CHILDRENを指定|
|usage|リソース使用量の書き込み先|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

getrusage()は、プロセスのリソース使用量を第2引数usageに書き込みます。  
- 第1引数whoがRUSAGE_SELF
> 自プロセスのリソース使用量を書き込みます。  
- 第1引数whoがRUSAGE_CHILDREN
> 子プロセスのリソース使用量を書き込みます。  

※ ここでいう子プロセスは自プロセスからfork()した子プロセスすべてのうち、wait()したものを意味します。
  
`man getrusage`を見ると、struct rusageにはたくさんのメンバがありますが、そのうち一部しか正しい値がセットされません。  
以下に意味のあるメンバのみ記載します。
|型|メンバ名|意味|
|:---|:---|:---|
|struct timeval|ru_utime|使われたユーザ時間|
|struct timeval|ru_stime|使われたシステム時間|
|long|ru_majflt|メジャーフォールトの回数|
|long|ru_minflt|マイナーフォールトの回数|
|long|ru_nswap|スワップサイズ|

struct timevalについては次節で説明します。  
#### システム時間
プロセスはシステムコールなどを通じて、カーネルを使用しています。  
対象のプロセスのためにカーネルが働いた時間のことをLinuxではシステム時間といいます。
#### ユーザ時間
システム時間以外の、プロセスが完全に自分で消費した時間のことをユーザ時間といいます。
#### メジャーフォールトとマイナーフォールト
どちらも物理アドレスに紐づけられていない仮想アドレスにアクセスして、その結果として物理ページの割り当てが起こった回数を示しています。  
メジャーフォールトはフォールトの中でディスク入出力が伴うもの、マイナーフォールトは伴わないものを指します。

## 14.6 日時と時刻
### ■ UNIX エポック
Linuxカーネルは時刻を1970年1月1日からの経過時間(整数)で保持しています。  
この(UTC時間で)1970年1月1日午前0時を俗にUNIXエポックといいます。

### ■ time(2)
```c
#include <time.h>

time_t time(time_t *tptr);
```
|引数|意味|
|:---|:---|
|tptr|経過秒数の書き込み先|

|戻り値|意味|
|:---|:---|
|成功|UNIXエポックから現在までの経過秒数|
|失敗||

time()は、UNIXエポックから現在までの経過秒数を返します。  
tptrがNULLでない場合は\*tptrに同じ値を書き込みます。  
time()では秒単位しか扱えないので、より精度の高い時刻が必要な場合はgettimeofday()システムコールを使用してください。

### ■ gettimeofday(2)
```c
#include <sys.time.h>

int gettimeofday(struct timeval *tv, struct timezone *tz);

struct timeval {
  long tv_sec;    /* 秒 */
  long tv_usec;   /* ミリ秒 */
};
```
|引数|意味|
|:---|:---|
|tv|経過秒数の書き込み先|
|tz|NULLを指定すること|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

gettimeofday()は、UNIXエポックから現在までの経過時間をtvに書き込みます。  
第2引数のtzはすでに使われていないので常にNULLを指定します。

### ■ localtime(3)、gmtime(3)
```c
#include <time.h>

struct tm *localtime(const time_t *timep);
struct tm *gmtime(const time_t *timep);
```
#### localtime(3)
|引数|意味|
|:---|:---|
|timep|time_t型で表された時刻|

|戻り値|意味|
|:---|:---|
|成功|struct tm型に変換された時刻|
|失敗|-1|

localtime()は、システムのローカルタイムゾーンを使います。
#### gmtime(3)
|引数|意味|
|:---|:---|
|timep|time_t型で表された時刻|

|戻り値|意味|
|:---|:---|
|成功|time_t型に変換された時刻|
|失敗|-1|

gmtime()は、協定世界時間(UTC)を使います。

localtime()とgmtime()はどちらも、time_t型で表された時刻をstruct tm型に変換します。  
※ struct tm型は時差を含む表現となっています。

### ■ mktime(3)
```c
#include <time.h>

time_t mktime(struct tm *tm);
```
|引数|意味|
|:---|:---|
|tm|struct tm型で表された時刻|

|戻り値|意味|
|:---|:---|
|成功|time_t型に変換された時刻|
|失敗|-1|

mktime()は、localtime()の逆でstruct tm型で表された時刻をtime_t型で表された時刻に変換します。

### ■ asctime(3)、ctime(3)
```c
#include <time.h>

char *asctime(const struct tm *tm);
char *ctime(const time_t *timep);
```

#### asctime(3)
|引数|意味|
|:---|:---|
|tm|struct tm型で表された時刻|

|戻り値|意味|
|:---|:---|
|成功|時刻を表す文字列|
|失敗|-1|

#### ctime(3)
|引数|意味|
|:---|:---|
|timep|time_t型で表された時刻|

|戻り値|意味|
|:---|:---|
|成功|時刻を表す文字列|
|失敗|-1|

asctime()とctime()は、時刻を表すデータを"Sat Sep 25 00:43:37 2004\n"のような形式の文字列に変換します。  
ただし、asctime()がstruct tmに含まれるタイムゾーン情報を考慮するのに対し、ctime()はUTC表記となることに注意します。

### ■ strftime(3)
```c
#include <time.h>

size_t strftime(char *buf, size_t bufsize, const char *fmt, const struct tm *tm);
```
|引数|意味|
|:---|:---|
|buf|バッファ|
|bufsize|バッファの上限|
|fmt|時刻フォーマット|
|tm|struct tm型の時刻|

|戻り値|意味|
|:---|:---|
|成功|bufに書き込んだバイト数|
|失敗|0|

strftime()は、第4引数tmの時刻をfmtに従ってフォーマットし、bufに書き込みます。  
※ ただし、bufsizeバイトまでしか書き込めません。

### ■ 時刻に関するAPIのまとめ
```
+----------------------------------------------------------+
|                         kernel                           | 
+----------------------------------------------------------+
            | time()                        | gettuneofday()
            |                               v
            |                 +----------------------------+
            |                 |  struct timeval            |
            |                 |  UNIXエポックからの経過秒数  |
            |                 +----------------------------+
            v
+----------------------------------------------------------+    ctime()
|  time_t(int)                                             | -------------> string
|  UNIXエポックからの経過秒数                                |
+----------------------------------------------------------+
            |               |               A
            | gmtime()      | localtime()   | mktime()
            v               v               |
+----------------------------------------------------------+   asctime()
|  struct tm                                               | -------------> string
|  時刻を暦で保持、TZ依存                                    |
+----------------------------------------------------------+
```

## 14.7 ログイン
### ■ ログインの流れ
1. initが端末の数だけgettyコマンドを起動
2. gettyコマンドは端末からユーザ名が入力されるのを待ち、loginコマンドを起動
3. loginコマンドがユーザを認証
4. シェルを起動

以下、詳しく見ていきます。
### ■ initとgetty
initは、カーネルが直接起動する唯一のプログラムであり、他のすべてのプロセスの祖先でした。  
しかしinitはそれだけでなく、ログインを待ち受けるプログラムgettyを起動するという役割も持っています。

### ■ 認証
システムによって大きく変わってしまう(例えば、NISやLDAPを使った認証をするなど)ため、差を吸収する仕組みが必要になります。  
その仕組みをPAMといい、PAMにはユーザを認証するAPIがあり、コマンドはこれを呼ぶだけで認証が行えます。

### ■ ログインシェル
認証が終われば、シェルをexecするだけです。  
このとき特殊なのが、execするときにコマンド名の頭に`-`を付けて起動することです。
```c
execl("/bin/sh", "-sh", ...);
```
このように起動したシェルをログインシェルといい、動作が少し変わります。(例えば、bashなら読み込む設定ファイルが増えたり、起動したコマンドの扱いが変わります。)

### ■ ログインの記録
どこでログイン情報について管理しているのか?

## 14.8 練習問題
1. プロセス・システム時間測定してみましょう。
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>

int main(void)
{
    struct rusage start_resource_usage, end_resource_usage;

    getrusage(RUSAGE_SELF, &start_resource_usage);

    /* CALC */
    int i;
    for (i=0; i<10000; i++) {
        printf("cnt = %d\n", i);
    }

    getrusage(RUSAGE_SELF, &end_resource_usage);

    printf("user\t%lfs\n",
        (end_resource_usage.ru_utime.tv_sec  - start_resource_usage.ru_utime.tv_sec) +
        (end_resource_usage.ru_utime.tv_usec - start_resource_usage.ru_utime.tv_usec)*1.0E-6);
    printf("sys\t%lfs\n",
        (end_resource_usage.ru_stime.tv_sec  - start_resource_usage.ru_stime.tv_sec) +
        (end_resource_usage.ru_stime.tv_usec - start_resource_usage.ru_stime.tv_usec)*1.0E-6);

    return 0;
}
```
2. 実時間を測定しましょう。
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>

int main(void)
{
    struct timeval start_real_time, end_real_time;

    gettimeofday(&start_real_time, NULL);

    /* SLEEP */
    sleep(10);

    gettimeofday(&end_real_time, NULL);

    printf("real\t%lfs\n",
        (end_real_time.tv_sec - start_real_time.tv_sec) +
        (end_real_time.tv_usec - start_real_time.tv_usec)*1.0E-6);

    return 0;
}
```
