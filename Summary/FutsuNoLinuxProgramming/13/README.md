# シグナルにかかわるAPI
## 13.1 シグナル
シグナルは、ユーザ(端末)やカーネルがプロセスに何かを通知する目的で使われます。  
シグナルにはいくつか種類があり、マクロで名前が付けられていますが、その実態はint型の整数値です。  
  
プロセスで特に設定をしていない場合は、配送されたシグナルの扱いをカーネルが決定し、処理します。  
処理方法は次の3つです。
1. 無視する
> SIGCHILD
2. プロセスを終了させる
> SIGINT
3. プロセスのコアダンプを作成して異常終了させる
> SIGSEGV

※ コアダンプとは、プロセスが使用するメモリのスナップショットのことです。

|シグナル名|捕捉|挙動|原因と用途|
|:---|:---|:---|:---|
|SIGINT|○|終了|割り込み</br>プログラムを中止したいときに使う|
|SIGHUP|○|終了|ユーザがログアウトしたときなどに生成される</br>デーモンプロセスでは設定ファイルの読み直しに使うことが多い|
|SIGPIPE|○|終了|切れたパイプに書き込むと生成される|
|SIGTERM|○|終了|プロセスを終了させるときに使う</br>killでシグナルを指定しなかったときのデフォルトの値|
|SIGKILL|×|終了|確実にプロセスを終了させるために使う|
|SIGCHILD|○|無視|子プロセスが停止または終了したときに生成される|
|SIGSEGV|○|コアダンプ|アクセスが禁止されているメモリ領域にアクセスしたときに生成される|
|SIGBUS|○|コアダンプ|アラインメント違反(ポインタ操作を間違えた時など)時に生成される|
|SIGFPE|○|コアダンプ|算術演算のエラー(ゼロ除算や浮動小数点のオーバーフローなど)によって生成される。|

### ■ シグナルの捕捉
シグナルの捕捉とは、そのシグナルが配送されたときの挙動を変更することができます。  
シグナルを受けた時のデフォルトの挙動はsigaction()というAPIを使って変更することが可能です。

## 13.2 シグナルを捕捉する
シグナルの処理をカーネルに任せず、自分でシグナルを捕捉(トラップ)するしてみます。
### ■ signal(2)
```c
#include <signal.h>

void (*signal(int sig, void (*func) (int)))(int);
```
見づらいのでtypedefを使って整形します。
```c
typedef void (*sighandler_t)(int);
sighandler_t signal(int sig, sighandler_t func);
```
sighandler_tのtypedefについて説明します。  
sighandler_t型とは、引数がint型で戻り値がvoidの関数へのポインタです。  
  

|引数|意味|
|:---|:---|
|sig|シグナル番号|
|func|シグナルハンドラ|

|戻り値|意味|
|:---|:---|
|成功|今まで設定していたハンドラ(SIG_DFL, SIG_IGN, シグナルハンドラfuncのアドレス)|
|失敗|SIG_ERR|
  
signal()は、シグナル番号sigのシグナルを受けたときの挙動を変更します。  
具体的には、シグナルを受けた時に第2引数funcの関数を呼ぶように挙動を変更します。  
  
このとき第2引数funcに渡す関数を、シグナルを処理する関数という意味でシグナルハンドラといいます。  
また、第2引数funcには次の表に示す特別な値も使えます。

|定数|意味|
|:---|:---|
|SIG_DFL|OSのデフォルト動作に戻す|
|SIG_IGN|カーネルレベルでシグナルを無視するように指示する|

最後に、signal()は直前までのシグナルハンドラを返します。

### ■ 関数ポインタ
関数ポインタについて説明します。  
使用例
```c
#include <stdio.h>
#include <stdlib.h>

int plus1(int n)
{
  return n + 1;
}

int main(int argc, char* argv[])
{
  int (*f)(int);          /* 関数を指すポインタ変数fを定義 */
  int result;
  
  f = plus1;              /* ポインタ変数fに関数plus1のポインタを代入している */
  result = f(5);          /* fに代入した関数(plus1)を実行 */
  printf("f result: %d\n", result);
  printf("plus1 address: %p\n", plus1);
  printf("f address: %p\n", f);
  exit(0);
}
```
`f = plus1`はplus1()を呼び出しているのではなく、plus1のポインタを代入している点に注意します。  
これは、char\*とchar[]の関係に似ていて、plus1と書くだけで関数の(機械語列)先頭へのポインタが得られます。  
※ `char* buf`や`char buf[64]`と定義した際、bufと書けばどちらの場合でも配列先頭へのポインタを得られます。

### ■ sigaction(2)
signal(2)を使わずにsigacion(2)でいきましょう。
```c
#include <signal.h>

int sigaction(int sig, const struct sigaction *act, struct sigaction *oldact);

struct sigaction {
  /* sa_handler, sa_sigactionは片方のみ使う */
  void (*sa_handler)(int);
  void (*sa_sigaction)(int siginfo_t*, void*);
  sigset_t sa_mask;
  int sa_flags;
};
```
|引数|意味|
|:---|:---|
|sig|シグナル|
|act|シグナルハンドラ|
|oldact|sigaction()呼び出し時のハンドラが返る(不要ならNULLを指定)|

|戻り値|意味|
|:---|:---|
|成功||
|失敗||

sigaction()は、シグナルsigのハンドラを登録します。  
struct sigactionの役割について触れます。
- ハンドラの再設定
> sigaction()は、OSにかかわらずシグナルハンドラの設定を保持し続けることが保証されます。
- システムコールの再起動
> sigaction()は、デフォルトではシステムコールを再起動しません。  
> sa_flagsメンバにフラグSA_RESTARTを追加すると、再起動する設定になります。
- シグナルのブロック
> struct sigactionのメンバsa_maskでブロックするシグナルを指定できます。  
> さらに、シグナルハンドラの起動中は処理中のシグナルを自動的にブロックしてくれるので、ほとんどの場合はsa_maskを空にしておけば十分です。  
> sa_maskを空にするには、後述するsigemptyset()を使います。

## ■ sigactionの使用例
一般的なsigaction()の使用例を次に示します。
```c
#include <signal.h>

typedef void (*sighandler_t)(int);

sighandler_t trap_signal(int sig, sighandler_t handler)
{
  struct sigaction act, old;
  
  act.sa_handler = handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = SA_RESTART;
  if (sigaction(sig, &act, &old) < 0)
    return NULL;
    
  return old.sa_handler;
}
```
まず、シグナルハンドラをsa_handlerにセットします。  
sa_handlerとsa_sigactionは片方しか使えないので、sa_sigactionは無視します。  
一般にシステムコールは自動的に再起動されたほうが便利なので、sa_flagsにはSA_RESTARTをセットします。  
最後に、sa_maskは空にしておけばよいので、sigemptyset()で空のままにしておきます。

### ■ sigset_t操作API
```c
int sigemptyset(sigset_t *set);
int sigfillset(sigset_t *set);
int sigaddset(sigset_t *set, int sig);
int sigdelset(sigset_t *set, int sig);
int sigismember(const sigset_t *set, int sig);
```
sigemptyset()は、setを空に初期化します。  
sigfillset()は、setをすべてのシグナルを含む状態にします。  
sigaddset()は、シグナルsigをsetに追加します。  
sigdelset()は、シグナルsigをsetから削除します。  
sigismember()は、シグナルsigがsetに含まれるとき真を返します。

### ■ シグナルのブロック
シグナルのブロックの設定は、sigaction()のsa_maskメンバでできました。  
他に必要なのは、ブロックしていたシグナルを配送してもらうためのAPIです。  
```c
#include <signal.h>

int sigprocmask(int how, sigset_t *set, sigset_t *oldset);
int sigpending(sigset_t *set);
int sigsuspend(const sigset_t *mask);
```
#### sigprocmask
sigprocmask()は、自プロセスのシグナルマスクをセット(有効化)します。  
セット方法はフラグhowで決まります。howに指定できる値は次の表の通りです。
|値|説明|
|:---|:---|
|SIG_BLOCK|setに含まれるシグナルをシグナルマスクに追加する|
|SIG_UNBLOCK|setに含まれるシグナルをシグナルマスクから削除する|
|SIG_SETMASK|シグナルマスクをsetに置き換える|

#### sigpending
保留されているシグナルをsetに書き込みます。
|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

#### sigsuspend
シグナルマスクmaskをセット(有効化)すると同時にプロセスをシグナル待ちにします。  
ブロックしていたシグナルを解除して、保留されていたシグナルを処理するときに使います。
|戻り値|意味|
|:---|:---|
|成功|-1|
|失敗|-1|

※ 常に-1を返すのは、いつでもシグナルに割り込まれて終了するためだかららしい(よくわからん?)

## 13.3 シグナルの送信
### ■ kill(2)
```c
#include <sys/types.h>
#include <signal.h>

int kill(pid_t pid, int sig);
```
|引数|意味|
|:---|:---|
|pid|プロセスID|
|sig|シグナル|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

kill()は、プロセスIDがpidのプロセスにシグナルsigを送信します。  
pidが負数のときは、IDが-pidのプロセスグループ全体にシグナルを送ります。  
※ プロセスグループにシグナルを送るシステムコールkillpg()もあります

## 13.4 Ctrl + C
ユーザがキーボードで`Ctrl + C`を押すと、これをカーネルの端末ドライバが検出します。  
端末ドライバはモードによって動きが違いますが、普通にシェルを使っているときはcookedモードになっているので、特殊な働きをするキーが存在します。  
どのキーがどのような働きをするかは、sttyコマンドを実行するとわかります。
```
# stty -a
```
出力の中に`intr = ^C;`とありますが、これは`Ctrl + C`が割り込みのことであることを意味します。  
`Ctrl + C`を押すと、端末ドライバは`Ctrl + C`を割り込みだと認識し、SIGINTを端末上で動作中のプロセス(正確にはプロセスグループ)に送信します。  
> 端末で動作しているプロセス(正確にはプロセスグループ)を特定するために、シェルがパイプでつながったプロセス群を起動するたびに「このプロセスグループが動いています」と端末に通知します。  
> 割り込みではパイプにつながれたプロセス全体を止めるのが望ましいので、通知されたプロセスグループ全体にシグナルを送信します。

## 13.5 練習問題
1. SIGINTシグナルを受けたらメッセージを出力するプログラムを書きなさい。シグナルを待つにはpause()というAPIが使えます。
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>

void handler(int no);

int main()
{
   struct sigaction sa;
   sigset_t unblock_mask, block_mask;

   // シグナル受信時のハンドラ(呼び出される関数)関連の設定
   sa.sa_handler = handler;
   sa.sa_flags = SA_RESTART;

   // シグナルマスク(ブロックするシグナルの集合)を初期化
   sigemptyset(&block_mask);

   // ブロックするシグナルをシグナルマスクとして設定(ここではSIGINT)
   // 対象となるシグナルセットするだけでまだブロックさせない
   sigaddset(&block_mask, SIGINT);
   // 直接sigactionのmaskに設定もできるので以下でもOK
   // sigaddset(&sa.sa_mask, SIGINT);

   // 設定したシグナルセットを有効化
   // マスクされたシグナルはブロック(正確には保留)される
   // 現在のマスク(未ブロックマスクセット)は第3引数に保持される
   sigprocmask(SIG_SETMASK, &block_mask, &unblock_mask);

   // 特定シグナル受信時の動作指示
   // SIGINTは先にマスク(ブロック対象)にしているので、この段階ではSIGINTのシグナルハンドラは動作しない
   sigaction(SIGINT, &sa, 0);

   // 標準入力を待つ間はSIGINTを受け付けるように変更
   // ブロックしないシグナルセットへ変更
   // sigactionで設定したSIGINTシグナルを受信時に指定したハンドラが呼び出される
   sigprocmask(SIG_SETMASK, &unblock_mask, NULL);

   // SIGINT 受付中...
   pause();

   // 標準入力を待つ間はSIGINTを受け付けないように変更
   // -> ブロックするシグナルセットへ変更
   //sigprocmask(SIG_SETMASK, &block_mask, &unblock_mask);

   // SIGINT 拒絶中...
   // この間にCtrl+Cを送ってもハンドラは動作しない(確認のため意図的にsleepする(その間にCtrl+Cを押してもハンドラは動作しない))
   //sleep(10);

   return 0;
}

void handler(int num)
{
    char *mes = "signal get\n";
    write(1, mes, strlen(mes));
}
```
Ref: https://alpha-netzilla.blogspot.com/2014/10/signal.html
