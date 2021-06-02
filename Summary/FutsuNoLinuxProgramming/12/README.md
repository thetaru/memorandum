# プロセスにかかわるAPI
## 12.1 基本的なプロセスAPI
### ■ fork(2)
```c
#include <sys/types.h>
#include <unistd.h>

pid_t fork(void);
```

|引数|意味|
|:---|:---|
|-|-|

|戻り値|意味|
|:---|:---|
|成功(親プロセス)|子プロセスのプロセスID(PID)|
|失敗(親プロセス)|-1|
|成功(子プロセス)|0|
|失敗(子プロセス)|0|

fork()は、カーネルはそのプロセスを複製し、2つのプロセスに分裂させます。  
分裂させた時点では、`複製前のプロセス`と`複製後のプロセス`はどちらもfork()を呼び出した状態になります。  
そして、2つのプロセスの両方にfork()の呼び出しが戻るので、両方のプロセスでfork()以後のコードが実行されます。  
このとき、複製元のプロセスを親プロセス、複製されたプロセスを子プロセスといいます。

### ■ exec(2)
```c
#include <unistd.h>

int execl(const char *path, const char *arg, ...);
int execlp(const char *file, const char *arg, ...);
int execle(const char *path, const char *arg, ..., char * const envp[]);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
int execvpe(const char *file, char *const argv[], char *const envp[]);
```

#### execl
コマンドの引数を可変長で取ります。  
また、最後はNULLにする必要があります。
```c
execl("/bin/ls", "-a", "-l", NULL);
```
#### execv
コマンドの引数をポインタの配列として取ります。  
また、配列の最初はファイル名へのポインタ、配列の最後はNULLにする必要があります。
```c
char *argv[] = {"/bin/ls", "-a", "-l", NULL};
res = execv(argv[0], argv);
```
#### execlp
指定されたファイル名に/(スラッシュ)が含まれていない場合、実行ファイルを環境変数PATHから探索し、シェルと同じように動きます。
```c
execlp("ls", "-a", "-l", NULL);
```
#### execle
環境変数を設定することができます。
```c
char *envp[] = {"ENV1=env1", "ENV2=env2", NULL};
execle("/usr/bin/env", "", NULL, envp);
```

|戻り値|意味|
|:---|:---|
|成功|-|
|失敗|-1|

execは、自プロセスを新しいプログラムで上書きするシステムコールです。  
execを実行すると、その時点で実行しているプログラムが消失し、自プロセス上に新しいプログラムをロードします。  
イメージとしては、プロセス上にもともとあるプログラムを新しいプログラムに上書きする感じです。  

### ■ wait(2)
```c
#include <sys/types.h>
#include <sys/wait.h>

pid_t wait(int *status);
pid_t waitpid(pid_t pid, int *status, int options);
```

|引数|意味|
|:---|:---|
|status|終了ステータスを格納する変数名|

|戻り値|意味|
|:---|:---|
|成功|子プロセスのプロセスID|
|失敗|-1|

wait()は、子プロセスのうちどれか1つが終了するのを待ちます。  
  
statusは子プロセスからの終了ステータスを格納する変数を指定します。終了ステータスが不要な場合は、NULLを指定します。  
  
終了ステータスは、終了の仕方を表すフラグとexit()の引数に渡した値をまとめたもので、次のマクロを使うと取得できます。  
|マクロ|意味|
|:---|:---|
|WIFEXITED(status)|exitで終了したら非0、それ以外なら0|
|WEXITSTATUS(status)|exitで終了していたときに、その終了コードを返す|
|WIFSIGNALED(status)|シグナルで終了していたら非0、それ以外なら0|
|WTERMSIG(status)|シグナルで終了したときに、そのシグナル番号を返す|

### ■ プログラムの実行
以上のシステムコールを使って、プログラムを実行して結果を待つ操作を実行してみます。
```c
/* FileName: spawn.c */
/* ProgName: spawn.o */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
  pid_t pid;
  
  if (argc != 3) {
    fprintf(stderr, "Usage: %s <command> <arg>\n", argv[0]);
    exit(1);
  }
  pid = fork();
  if (pid < 0) {
    fprintf(stderr, "fork(2) failed\n");
    exit(1);
  }
  if (pid == 0) { /* 子プロセス */
    execl(argv[1], argv[1], argv[2], NULL);
    /* execl()が呼び出しから戻ったら失敗 */
    /* つまり成功した場合はperrorとexitに到達しない */
    perror(argv[1]);
    exit(99);
  } else {        /* 親プロセス */
    /* pidには子プロセスのPIDが格納されていることに留意する */
    int status;
    
    waitpid(pid, &status, 0);  /* pidは子プロセスのPIDなので子プロセスの終了を待つ */
    printf("child (PID=%d) finished; ", pid);
    if (WIFEXITED(status))
      printf("exit, status=%d\n", WEXITSTATUS(status));
    else if (WIFSIGNALED(status))
      printf("signal, sig=%d\n", WTERMSIG(status));
    else
      printf("abnormal exit\n");
    exit(0);
  }
}
```
## 12.2 プロセスの一生
### ■ \_exit(2)
```c
#include <unistd.h>

void _exit(int status);
```

\_exit()は、statusを終了ステータスとしてプロセスを終了します。  
\_exit()は絶対に失敗しないので、呼び出されたら戻りません。

### ■ exit(3)
```c
#include <stdlib.h>

void exit(int status);
```
exit()は、statusを終了ステータスとしてプロセスを終了します。  
exit()は絶対に失敗しないので、呼び出されたら戻りません。
  
exit()と_exit()の違いは次の2点です。
- exit()はstdioのバッファを全部フラッシュする
- exit()はatexit()で登録した処理を実行する

つまり、exit()はlibcの関数で_exit()はシステムコールなので、libcに関連した各種後始末をするかしないかの違いです。

### ■ 終了ステータス
成功・失敗のみの場合は、`EXIT_SUCCESS`と`EXIT_FAILURE`というマクロを使い、細かくステータスを分ける場合は、数値を使いましょう。

## 12.3 パイプ
### ■ パイプ
パイプとは、プロセスからプロセスにつながったストリームのことでした。  
ファイルにつながったストリームと同様に、パイプもファイルディスクリプタを使って表現できます。  

### ■ pipe(2)
```c
#include <unistd.h>

int pipe(int fds[2]);
```

|引数|意味|
|:---|:---|
|fds[2]|パイプ両端のプロセスのファイルディスクリプタ</br>fds[0]がパイプの読み込み側でfds[1]がパイプの書き込み側です|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

### ■ 親子プロセス間をパイプでつなぐ 
pipe()でパイプを作成後、fork()でプロセスを複製するとストリームもすべて複製され次のようになります。  
※ 複製されたストリームを親と子は共有する?
```
   parent              child
+-----------+       +-----------+
|  fds[0] <-|---+---|-> fds[0]  |
|  process  |   |   |  process  |
|  fds[1] --|---+---|-- fds[1]  |
+-----------+       +-----------+
```
ここで、親が読み込み側でclose()し、子が書き込み側をclose()すると次のようになります。
```
   parent              child
+-----------+       +-----------+
|  fds[0]   |   +---|-> fds[0]  |
|  process  |   |   |  process  |
|  fds[1] --|---+   |   fds[1]  |
+-----------+       +-----------+
```
これで親から子へのパイプができました。  

### ■ dup(2)、dup2(2)
pipe()とfork()でプロセス間にパイプを作ることができるようになりました。  
しかし、指定のファイルディスクリプタにパイプをつなぐことがまだできていません。(つまり、リダイレクションのことです。)
```c
#include <unistd.h>

int dup(int oldfd);
int dup2(int oldfd, int newfd);
```
#### dup()
|引数|意味|
|:---|:---|
|oldfd|複製元ファイルディスクリプタ|

#### dup2()
|引数|意味|
|:---|:---|
|oldfd|複製元ファイルディスクリプタ|
|newfd|複製先ファイルディスクリプタ|

|戻り値|意味|
|:---|:---|
|成功|複製されたファイルディスクリプタ(正の整数)|
|失敗|-1|

dup()とdup2()は、ファイルディスクリプタoldfdを複製します。  
dup()は、未使用のファイルディスクリプタから最小番号を割り当てます。  
dup2()は、ファイルディスクリプタoldfdをファイルディスクリプタnewfdに複製します。  
  
ちなみに、複製元ファイルディスクリプタと複製先ファイルディスクリプタは連動しており、片方のファイルディスクリプタでした操作はもう片方でもしたことになります。  
  
リダイレクション手順は以下の通りです。  
例として3番につながっているパイプを0番に移します。
1. close(0);
2. dup2(3,0);
3. close(3)

※ 使わないストリームはキッチリ処理(close)しましょう!!!

### ■ popen(3)
リダイレクションはpipe()とfork()とdup()の組み合わせで実現しました。  
stdioにはパイプ接続用APIがあるのでそれを使います。
```c
#include <stdio.h>

FILE *popen(const char *command, const char *mode);
```
|引数|意味|
|:---|:---|
|command|コマンド文字列|
|mode|モード("r"\|"w")|

|戻り値|意味|
|:---|:---|
|成功|子プロセス(コマンド)へのパイプを表すstdioストリーム|
|失敗|NULL|

popen()は、commandで渡された文字列を/bin/sh(正確には/bin/sh -c)に渡すことでコマンドを実行します。  

### ■ pclose(3)
```c
#include <stdio.h>

int pclose(FILE *stream);
```
pclose()は、popen()でfork()した子プロセスをwait()し、そのあとにストリームを閉じます。  
popen()で開いたFILE\*は必ずpclose()で閉じなければなりません。

## 12.4 プロセスの関係
### ■ 親子関係
pstreeでプロセスの親子関係を表示することができます。

### ■ getpid(2)、getppid(2)
```c
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void);
pid_t getppid(void);
```
getpid()は、自分のプロセスIDを返します。  
getppid()は、親プロセスのプロセスIDを返します。

### ■ セッションとプロセスグループ
すべてのプロセスはそれぞれただ1つのプロセスグループとセッションに所属しています。  
以下かなり薄い説明をするため注意してください。  
#### プロセスグループ
プロセス群を1つのプロセスグループで一元管理することで、まとめて扱えるようにする。(シグナルをまとめて送るなどできるようになる)
#### セッション
ユーザのログインからログアウトまでの流れを管理するための概念です。  
ログインシェルを起点に、ユーザがセッションと紐づく制御端末(e.g. tty1など)から起動したプロセスを1つにまとめる働きをします。

### ■ リーダー
psコマンドをjオプション付きで実行するとセッションやプロセスグループを見ることができます。
|表示名|意味|
|:---|:---|
|PID|プロセスID|
|PPID|親のプロセスID|
|PGID|プロセスグループID|
|SID|セッションID|

PIDとSIDが等しいプロセスをセッションリーダーといい、最初にそのセッションを作ったプロセスです。  
PIDとPGIDが等しいプロセスをプロセスグループリーダーといい、最初にそのプロセスグループを作ったプロセスです。

### ■ デーモンプロセス
ps axと打つとマシン上の全プロセスが表示されます。  
TTYの欄の中で値が`?`となっているプロセスが多数あります。  
これは制御端末がないプロセスであることを意味していて、このようなプロセスのことをデーモンプロセスといいます。  
制御端末あるとログアウト時などにプロセスを止められてしまうので、プロセスを常駐させる場合はデーモン化させます。

### ■ setsid(2)
```c
#include <unistd.h>

pid_t setsid(void);
```

|引数|意味|
|:---|:---|
|-|-|

|戻り値|意味|
|:---|:---|
|成功|作成したセッションID|
|失敗|-1|

setsid()は、新しいセッションを作成し、自分がセッションリーダーとなります。  
同時に、そのセッションで最初のプロセスグループを作成し、そのプロセスグループリーダーになります。  
自プロセスがすでにプロセスグループリーダーになっている場合は失敗するので、あらかじめfork()してプロセスグループリーダーでなくす必要があります。
