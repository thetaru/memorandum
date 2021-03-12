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
※ `*array`はarrayの先頭アドレスへのポインタを意味します。  
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
C言語には標準関数という関数が存在します。  
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
ただし、str2の長さがn以上のときはn文字コピーしますが、NULL文字`\0`の自動付与は行われません。
```
(n=5の場合) コピー元 -> コピー先 の 図
"HELLO" = { 'H', 'E', 'L', 'L', 'O', '\0' } -> { 'H', 'E', 'L', 'L', 'O' }
```
こういう場合には、自分で文字列の最後にNULL文字を付与してあげる必要があります。  
実際にstrncpy関数を使ってプログラムを書いてみます。
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char souce[20] = "HelloWorld";
  char dest[20];
  
  strncpy( dest, souce, 5 );
  dest[5] = '\0'; /* NULL文字を付与 */
  printf("コピーされた文字列は%sです\n", dest);
  return 0;
}
```
#### definition - strlen関数
```c
size_t strlen( const char* str )
```
strlen関数は引数strの文字数を返す関数です。  
ただし文字列の最後のNULL文字は文字数に含まれません。  
ちなみに`size_t`は`unsigned int`とほぼ同じです。
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char source[20] = "hello";
  printf("文字列の長さは %d です\n", strlen( source ));
  return 0;
}
```
#### definition - strcat関数
```c
char* strcat( char* str1, const char* str2 );
```
strcat関数は文字列str1の後ろにstr2の文字列を連結させる関数です。
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char source[80] = "World";
  char dest[80] = "Hello";
  
  strcat( dest, source );
  printf("文字列 %s\n", dest);
  return 0;
}
```
#### definition - strncat関数
```c
char* strncat( char* str1, const char* str2, size_t n );
```
strncat関数は文字列str1の後ろにstr2の文字列をn文字分連結させる関数です。  
(疑問)NULL文字は追加しなくていいのかな?
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char dest[20] = "ABC";
  char source[20] = "DEFGH";
  
  strncat( dest, source, 3 );
  printf("文字列 %s\n", dest);
  return 0;
}
```
#### definition - strcmp関数
```c
int strcmp( const char* str1, const char* str2 );
```
strcmp関数は文字列str1と文字列str2の内容を比較し、その結果を戻り値として返します。  
等しい場合は0をそうでない場合は0以外の整数を返します。  
※ 辞書順序(>) で str1 > str2 ⇒ 負数, str1 < str2 ⇒ 正数
```c
#include <stdio.h>
#include <string.h>

int main(void)
{
  char source[80] = "Hello";
  char dest[80] = "Hello";
  
  if( strcmp( source, dest ) == 0 ) {
    printf("２つの文字列は等しいです\n");
  } else {
    printf("２つの文字列は異なります。\n");
  }
  return 0;
}
```
### 4.6.2 入出力関係の処理
画面への文字列の出力・キーボードからの入力などの処理を行う関数を紹介します。  
以下に紹介する関数を使う場合は`stdio.h`をインクルードする必要があります。
#### definition - putchar関数
```c
int putchar( int c );
```
cで指定した1文字を表示します。
```c
#include <stdio.h>

int main(void)
{
  putchar('a');
}
```
#### definition - puts関数
```c
int puts ( const char *str );
```
strで指定した文字列を表示します。  
printfと違い変換指定子(%dや%sなど)を使うことはできません。  
文字列の最後には改行`\n`が自動的に付与されます。(なので改行のための`\n`は不要です。)
```c
#include <stdio.h>

int main(void)
{
  puts("Hello World");
}
```
#### definition - getchar関数
```c
int getchar(void);
```
キーボードから1文字受け取ります。
```c
#include <stdio.h>

int main()
{
  char ch;
  
  printf("文字を入力してください: ");
  ch = getchar();
  
  printf("受け取った文字: %c\n", ch);
  return 0;
}
```
#### definition - gets関数
```c
char *gets ( char *str );
```
キーボードから文字列を受け取ります。  
scanfと違い文字列にスペースが含まれていてもスペースも含めて文字列として読み込まれます。  
※ コンパイラによってはgets関数はあぶないので使うなと言われるかもしれません。
```c
#include <stdio.h>

int main()
{
  char str[80];
  
  printf("文字列を入力してください: ");
  gets( str );
  printf("受け取った文字列: %s\n", str);
  return 0;
}
```
#### definition - fgets関数
```c
char *fgets( char *string, int n, FILE *stream );
```
streamからn-1文字分の文字列を受け取りstringに代入します。  
※ streamとはファイル操作を扱う部分で登場するものです。(e.g. stdinなど)
streamにstdinを指定するとキーボードから文字列を受け取れるようになります。
```c
#include <stdio.h>

int main()
{
  char str[80];
  
  printf("文字列を入力してください: ");
  fgets( str, 6, stdin );
  printf("文字列: %s\n", str);
  return 0;
}
```
### 4.6.3 数学関連の処理
以下に紹介する関数を使う場合は`math.h`をインクルードする必要があります。  
また数学関連のライブラリを利用する際は`gcc math.c -o math.o -lm`のようにコンパイルします。
#### definition - sin関数
```c
double sin( double arg );
```
sin関数はarg(radius)を引数にとります。
```c
#include <stdio.h>
#include <math.h>

int main(void)
{
  double value = -1.0;
  printf("%fのsinの値は%fです\n", value, sin( value ));
  return 0;
}
```
#### definition - cos関数
```c
double cos( double arg );
```
cos関数はarg(radius)を引数にとります。
```c
#include <stdio.h>
#include <math.h>

int main(void)
{
  double value = -1.0;
  printf("%fのcosの値は%fです\n", value, cos( value ));
  return 0;
}
```
#### definition - pow関数
```c
double pow( double x, double y );
```
pow関数はxのy乗を戻り値として返します。
```c
#include <stdio.h>
#include <math.h>

int main(void)
{
  double x = 2.0, y = 5.0;
  printf("%fの%f乗は%fです\n", x, y, pow( x, y ));
  return 0;
}
```
### その他の関数
以下に紹介する関数を使う場合は`stdlib.h`をインクルードする必要があります。  
#### definition - atoi関数
```c
int atoi( const char *string );
```
stringで指定した文字列をint型の数値に変換した結果を戻り値として返します。  
stringで指定する文字列は整数の文字列表現でなくてはいけません。(e.g. `12`はOK, `Ten`はNG)  
```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  char str[] = "150";
  
  printf("文字列%sを数値%dに変換しました\n", str, atoi( str ));
  return 0;
}
```
