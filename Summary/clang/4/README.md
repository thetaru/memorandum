# 関数
## 4.1 関数とは
関数とはいくつかの命令文をまとめたものです。
## 4.2 関数を作ってみる
#### Syntax - 関数
```c
型 関数名 ( 引数 ) { 関数の中身 }
```
実際に2つの値を入力して、その和を求める関数を作ってみます。
```c
#include <stdio.h>

int Plus(int x, int y) /* 仮引数: x, y */
{
  int result;
  result = x + y;
  return result;
}

int main(void)
{
  int hoge, piyo;
  int n;
  
  printf("2つの整数を入力してください\n");
  printf("1つ目: "); scanf("%d", &hoge);
  printf("2つ目: "); scanf("%d", &fuga);
  
  n = Plus(hoge, piyo); /* 実引数: hoge, piyo */
  printf("足し算の結果は%dです\n", n);
  return 0;
}
```
以下のことに注意してください。
- main関数の前にPlus関数を定義してください。  
なぜこのようにしなければならないかは後で登場するプロトタイプ宣言のところで説明します。  
- 関数名はすでに使われている関数名や変数名を使わないでください。  
自分で定義したものだけでなく既に定義されているもの(e.g. printfなど)に対しても配慮してください。
- 関数の返り値(return)は関数宣言時に指定した型と一致させてください。  
(e.g. int型の関数ならその返り値もint型でなくてはいけません)  
  
呼び出した側の引数を実引数といい、呼び出された側の引数を仮引数といいます。  
このとき実引数の値が仮引数の値にコピーされます。(あくまでコピーであり関数の実行によって変数の実態に影響を与えないことに注意します。)  
  
returnは関数から値を返す場合に使用します。
## 4.3 プロトタイプ宣言
定義する関数を事前にコード上部に宣言してしまいましょうってモチベーションです。  
C言語で書いたコードは上から下へ実行されます。  
例として次のようなコードを書いたとします。
```c
#include <stdio.h>

int main(void)
{
  Test2();
  return 0;
}

void Test2(void)
{
  printf("TEST FUNCTION\n");
}
```
このコードをコンパイルするとエラーが発生します。  
main関数内でTest2関数を呼び出していますが、この時点ではTest2関数は未定義です。  
このような場合にプロトタイプ宣言を使用します。
```c
#include <stdio.h>

void Test2(void); /* プロトタイプ宣言 */

int main(void)
{
  Test2();
  return 0;
}

void Test2(void)
{
  printf("TEST FUNCTION\n");
}
```
main関数を宣言するより前にTest2関数という関数がこれから定義されますよって言っているようなものです。
## 4.4 配列を引数として渡す
引数には配列を渡すこともできます。(実際は渡しているように見せているだけ)  
次のコードを見てください。
```c
#include <stdio.h>

void show(int array[5], int n)
{
  int i;
  for ( i = 0; i < n; i++ ) {
    printf("%d\n", array[i]);
  }
}

int main()
{
  int array[] = { 1, 2, 3, 4, 5 };
  show( array, 5 );
  return 0;
}
```
次のように書き換えても同じように動きます。
```c
/* 変更点: array[5] -> array[] */
void show(int array[], int n)
{
  int i;
  for ( i = 0; i < n; i++ ) {
    printf("%d\n", array[i]);
  }
}
```
3章でも少しだけ説明しましたが、配列を引数として渡すと配列の先頭アドレスへのポインタ(e.g. &array[0] または \*array)を渡すようになっています。  
※ `*array`はarrayのポインタを意味します。  
以下のように書いても同じです。
```c
/* 変更点: array[5] -> array[] -> *array */
void show(int *array, int n)
{
  int i;
  for ( i = 0; i < n; i++ ) {
    printf("%d\n", array[i]);
  }
}
```
## 4.5 main関数
実はmain関数が最初に呼び出される関数ではない。  
またmain関数の戻り値は使われることがあるため`void main`ではなく`int main`(e.g. main関数の戻り値が0なら正常終了、0以外なら異常終了とみなす)である必要がある。
## 4.6 標準関数
C言語には標準言語という関数が存在します。  
これはよく使われる処理があらかじめ関数として用意されており別ファイルに既に定義されています。(e.g. printf関数, scanf関数,...)  
例えば、printf関数は`stdio.h`というファイルに定義されていて、`#include <stdio.h>`からこのファイルをインクルードすることでprintf関数を使用できるようになります。
### 4.6.1 文字列関連の処理
文字列の処理に用いる関数は`string.h`に定義されています。  
そのため以下に紹介する関数を使う場合は`string.h`をインクルードする必要があります。
#### definition - strcpy関数
```c
char *strcpy( char* str1, const char* str2 );
```
strcpy関数は文字列をコピーする際に使います。  
1つ目の引数に２つ目の引数の内容をコピーします。
実際にstrcpy関数を使ってプログラムを書いてみます。
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char souce[20] = "hello";
  char dest[20];
  
  strcpy( dest, souce );
  printf("コピーされた文字列は%sです\n", dest);
  return 0;
}
```
#### definition - strncpy関数
```c
char *strncpy( char* str1, const char* str2, size_t n );
```
strcpy関数は文字列を部分コピーする際に使います。  
1つ目の引数に2つ目の引数の内容をn文字だけコピーします。  
ただし、str2の長さがn以上のときはn文字コピーしますが、NULL文字の自動付与は行われません。
```
### (n=5の場合) コピー元 -> コピー先 の 図
{ 'H', 'E', 'L', 'L', 'O', '\0' } -> { 'H', 'E', 'L', 'L', 'O' }
```
実際は、目に見える文字列の長さ(e.g. "HELLO"だと長さ5)にNULL文字分が加わる(i.e. 実際の長さは6)ことに注意すること。
