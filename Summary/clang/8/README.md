# メモリ管理とファイル入出力
## 8.1 動的メモリ割り当て
### 8.1.1 malloc関数とfree関数
C言語には動的メモリ割り当てを行える`malloc`という関数があります。    
malloc関数はstdlib.hに定義されています。  
そのためstring.hをインクルードする必要があります。
#### Syntax - malloc関数
```c
ポインタ変数 = malloc( メモリバイト数 );
```
malloc関数はメモリバイト数で割り当てた領域の先頭を指すポインタを返します。  
メモリの割り当てに失敗した場合はNULLポインタが返ってきます。  
  
割り当てたメモリはプログラムが終了するまで確保されますが、メモリが不要になった場合に自分で開放してやる必要があります。  
メモリの開放にはfree関数を使用します。
#### Syntax - free関数
```c
free( ポインタ変数 );
```
ポインタ変数がつかんでいるメモリを解放します。  
  
実際にint型の要素数5の配列を宣言してみます。
```c
int* p;
p = (int*)malloc( 4 * 5 );

if ( !p ) {
  printf("メモリ割り当て失敗\n");
  exit(1);
}
```
int型のサイズを4byteとして　5要素分のメモリ領域(= 4\*5 = 20byte)を確保します。  
上の場合は解説のしやすさからint型を4byteとしましたが、実際の場合は次のように`sizeof`を使って型のサイズを取得しましょう。
```c
int* p;
p = (int*)malloc( sizeof(int) * 5 );

if ( !p ) {
  printf("メモリ割り当て失敗\n");
  exit(1);
}
```
ちなみにexit関数はプログラムを終了させる関数です。  
exit関数に**0**を渡せば**正常終了**、**0以外の数値**を渡せば**異常終了**となります。
### 8.1.2 malloc関数とfree関数の使用例
実際にmalloc関数とfree関数を使ってみます。
```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int* buf;
  int number, i, sum;
  
  printf("入力データ: ");
  scanf("%d", &number);
  
  buf = (int*)malloc( number * sizeof(int) );
  
  if ( !buf ) {
    printf("メモリ割り当て失敗\n");
    exit(1);
  }
  
  for ( i = 0; i < number; i++ ) {
    printf("%d個目のデータ: ", i+1);
    scanf("%d", &buf[i]);
  }
  
  for ( i = 0, sum = 0; i < number; i++ ) {
    sum += buf[i];
  }
  
  printf("合計: %d\n", sum);
  free( buf );
  return 0;
}
```
## 8.2 ファイル入出力
### 8.2.1 ストリーム
ファイル入出力においてストリームという概念があります。  
C言語では任意の入出力デバイス(e.g. キーボード、ディスプレイなど)で同じ手法で操作することになります。  
これができるのはストリームという抽象的なインターフェースを操作できるから可能なのです。
### 8.2.2 ファイル開閉
ファイルを操作する際もストリームを扱います。
### 8.2.2.1 開
はじめにファイルを開く方法について学びます。  
まずファイルを開きストリームと結びつける必要があります。  
そのためにはFILE構造体とfopen関数を使います。(どちらもstdio.hに定義されています。)
#### Syntax - ファイルの開き方
```c
FILE* fp = fopen( char* ファイル名, char* モード );
``` 
fopen関数はファイル名とファイルモードを渡すとFILE構造体のポインタを返します。  
このFILE構造体がストリームで、これらを使ってファイルの入出力を行います。  
  
ここでモードという引数をとっています、このモードは次の表にある文字列を渡すことでファイルのモードを選択できます。
|モード|説明|
|:---|:---|
|r|読み込み用にテキストファイルを開く<br />ファイルが見つからなかった場合、fopen関数はNULLを返す|
|w|書き込み用にテキストファイルを開く<br />ファイルが既に存在していた場合、その内容を破棄する|
|a|テキストファイルにデータを追加するく<br />ファイルが存在しなかった場合、ファイルを新たに作成する|
|rb|読み込み用にバイナリファイルを開く|
|wb|書き込み用にバイナリファイルを開く|
|ab|バイナリファイルにデータを追加する|
|r+|読み込み/書き込み用にテキストファイルを開く|
|w+|読み込み/書き込み用にテキストファイルを作成する|
|a+|読み込み/書き込み用にテキストファイルを追加する|

テキストモード(r,w,a)とバイナリモード(rb,wb,ab)があります。  
テキストモードでは主にASCII文字列を扱い文字変換が行われますが、バイナリモードでは文字変換は行われません。
### 8.2.2.2 閉
ファイルは開けたら必ず閉じなければなりません。  
ストリームからファイルを切り離すにはfclose関数を使用します。
#### Syntax - fclose
```c
fclose( FILE* ストリーム );
```
実際に指定したファイルが(カレントディレクトリに)存在するかどうかを確認するプログラムを作成します。
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[1000];
  FILE* fp;
  
  printf("ファイル名: ");
  scanf("%s", filename);
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  printf("ファイルを正常に開くことができました\n");
  
  fclose(fp);
  return 0;
}
```
### 8.2.3 ファイル読み込み
### 8.2.3.1 1文字ごとの読み込み
開いたファイルの内容を表示させてみましょう。  
ファイルから文字を取得するにはfgetc関数を使用します。
#### Syntax - fgetc関数
```c
int fgetc( FILE* ストリーム );
```
fgetc関数はストリームからunsigned char型の値を1文字読み込み、int型の値として返します。  
ソースファイルと同じ場所にtest.txtというファイルを作成し読み込んでみます。   
test.txtの中身は次のようにします。
```
hello
world
363
```
実際にプログラムを書いてみます。  
fgetc関数で取得した文字を表示するプログラムです。
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[100] = "test.txt";
  FILE* fp;
  int ch;
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  for (;;) {
    ch = fgetc( fp );
    if ( ch == EOF ) {
      break;
    }
    printf("%c", ch);
  }
  printf("\n");
  
  fclose(fp);
  return 0;
}
```
chがEOF(End Of File)となるまでループを続けます。  
EOFはファイルの読み込みエラーまたはファイルの最後に到達した際にfgetcが返します。
実行してみるとtest.txtの中身と同じものが出力されました。
### 8.2.3.2 1行ごとの読み込み

#### Syntax - fgets関数
fgets関数はストリームから1行を読み込みます。
```c
char* fgets( char* 文字列, int サイズ, FILE* ストリーム );
```
第1引数の`文字列`に`ストリーム`から`サイズ-1`個以下の文字を読み込み格納します。  
改行文字やEOFより後の文字は読まれません。読み込んだ文字の最後にはNULL文字を加えます。  
読み込みに失敗した場合やEOFの場合は、NULLを返します。  
  
今回も上で作成したtest.txtを使います。  
実際にfgets関数を使ったプログラムを書いていきます。
```c
#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 100

int main()
{
  char filename[100] = "test.txt";
  char buf[BUFSIZE];
  FILE* fp;
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  while ( fgets( buf, BUFSIZE, fp ) != NULL ) {
    printf("%s", buf);
  }
  printf("\n");
  fclose(fp);
  return 0;
}
```
fgets関数がNULLを返すまでループを続けます。
### 8.2.3.3 書式文字列に従ったデータの読み込み
#### Syntax - fscanf関数
```c
int fscanf( FILE* ストリーム, char* フォーマット, ... );
```
fscanf関数は`フォーマット`が指す書式文字列に従って`ストリーム`からデータを読み込み、`フォーマット`に続く引数の指すオブジェクトに代入します。    
先程のプログラムをfscanf関数を使って書き換えてみます。
```c
#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 100

int main()
{
  char filename[100] = "test.txt";
  char buf[BUFSIZE];
  FILE* fp;
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  while ( fscanf( fp, "%s", buf ) != EOF ) {
    printf("%s\n", buf);
  }
  printf("\n");
  fclose(fp);
  return 0;
}
```
## 8.2.4 ファイル書き込み
### 8.2.4.1 1文字ごとの書き込み
ファイルにデータを書き込んでみましょう。  
1文字ずつファイルに書き込んていくときはfputc関数を使用します。
#### Syntax - fputc関数
```c
int fputc( int 文字, FILE* ストリーム );
```
out.txtというファイルにhelloという文字を書き込んでみましょう。  
ファイルモードは書き込みなので"w"にします。
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[100] = "out.txt";
  char buf[100] = "hello";
  FILE* fp;
  int i;

  fp = fopen(filename, "w");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  for ( i = 0; buf[i] != '\0'; i++ ) {
    fputc( buf[i], fp );
  }
  printf("ファイル書き込み完了\n");
  fclose(fp);
  return 0;
}
```
out.txtに書き込まれていることを確認しましょう。
### 8.2.4.2 1行ごとの書き込み
fputs関数はストリームから1行を書き込みます。
#### Syntax - fputs関数
```c
int fputs( char* 文字列, FILE* ストリーム );
```
fputs関数は書き込みに失敗するとEOFを返します。  
先程のプログラムをfputs関数を使って書き換えましょう。
```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  char filename[100] = "out.txt";
  char buf[100] = "hello";
  FILE* fp;
  
  fp = fopen(filename, "w");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  if ( fputs( buf, fp ) != EOF ) {
    printf("ファイル書き込み完了\n");
  } else {
    printf("書き込み失敗\n");
  }
  fclose(fp);
  return 0;
}
```
### 8.2.4.3 書式文字列に従ったデータの書き込み
#### Syntax - fprintf関数
```c
int fprintf( FILE* ストリーム, char* フォーマット, ... );
```
fprintf関数は`フォーマット`が指す書式文字列に従って`フォーマット`に続く引数の指すオブジェクトを代入し、`ストリーム`へデータを書き込みます。  
先程のプログラムをfprintf関数を使って書き換えてみます。
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[100] = "out.txt";
  char buf[100] = "hello";
  FILE* fp;
  
  fp = fopen(filename, "w");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  fprintf( fp, "%s", buf );
  printf("ファイル書き込み完了\n");
  fclose(fp);
  return 0;
}
```
## 8.2.5 ファイル終端の判定とエラーチェック
### 8.2.5.1 ファイル終端の判定
fgetcやfgets関数などはファイルの終端に達するもしくはエラーが発生した場合にEOFを返しました。  
しかし、EOFは次のように定義されています。(※環境依存です。)
```c
#define EOF -1
```
もし読み取った値が-1であった場合、EOFと判定されてしまいます。  
この問題を解決するためにfeof関数を使用します。
#### Syntax - feof関数
```c
int feof( FILE* ストリーム );
```
feof関数は**エラーが発生**した又は**ファイルの終端**に達した場合に**0以外の値**を**それ以外**の場合に**0**を返します。  
実際にtest.txtを読み込むプログラムをfeof関数を使用して書き換えてみます。
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
  char filename[100] = "test.txt";
  FILE* fp;
  int ch;
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けられませんでした\n");
    exit(1);
  }
  
  for (;;) {
    ch = fgetc( fp );
    if ( !feof( fp ) ) {
      printf("%c", ch);
    } else {
      break;
    }
  }
  printf("\n");
  fclose(fp);
  return 0;
}
```
### 8.2.5.2 エラーチェック
エラーをチェックするferror関数も存在します。  
この関数はストリームでエラーが発生すると0以外の値を返します。
#### Syntax - ferror関数
```c
int ferror( FILE* ストリーム );
```
先程のプログラムにferror関数を加えてみます。
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
  char filename[100] = "test.txt";
  FILE* fp;
  int ch;
  
  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けられませんでした\n");
    exit(1);
  }
  
  for (;;) {
    if ( ferror( fp ) ) {
      printf("ファイルエラー発生\n");
      break;
    }
    
    ch = fgetc( fp );
    if ( !feof( fp ) ) {
      printf("%c", ch);
    } else {
      break;
    }
  }
  printf("\n");
  fclose(fp);
  return 0;
}
```
## 8.3 標準ストリーム
C言語には標準ストリームというものが3つ存在しています。  
それぞれ、標準入力(stdin) 標準出力(stdout) 標準エラー(stderr) です。  
デフォルトでは標準入力はキーボード、標準出力と標準エラーがディスプレイです。  
  
まずは標準出力から見ていきます。  
画面上にHello Worldと表示するプログラムをfprintf関数を使用して作成します。
```c
#include <stdio.h>

int main()
{
  fprintf( stdout, "Hello World\n");
  return 0;
}
```
次にキーボードから文字列を受け取り、その文字列を表示するプログラムを作成してみます。
```c
#include <stdio.h>

int main()
{
  char buf[100];
  
  printf("文字列を入力: ");
  fscanf( stdin, "%s", buf );
  fprintf( stdout, "入力した文字列: %s\n", buf );
  return 0;
}
```
## 8.4 セキュアプログラミング
bufferoverrunについて書いてあったけど、これだけではあまりに足らないので書かないことにしました。
## 8.5 例題
### 8.5.1 ファイルサイズを求めるプログラム
やることは主に3つ
- ファイル名の取得
- 受け取ったファイル名には改行が含まれるのでそれをNULL文字に置換
- 1文字(1byte)ずつ受け取っていきファイルサイズを計算
```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFMAX 100

int main()
{
  char filename[BUFMAX];
  FILE* fp;
  int size = 0, i;
  
  /* 標準入力でファイル名を受け取る */
  printf("ファイル名: ");
  fgets( filename, BUFMAX, stdin );
  
  /* 改行を削除する */
  i = strlen( filename ) - 1;
  if ( filename[i] == '\n' ) {
    filename[i] = '\0';
  }
  
  fp = fopen( filename, "rb" );
  
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  while ( !feof( fp ) ) {
    fgetc( fp );
    size++;
  }
  size--; /* NULL文字分を削除 */
  
  printf("ファイルサイズ: %d\n", size);
  fclose( fp );
  return 0;
}
```
### 8.5.2 平均点を求めるプログラム
次のような成績ファイル(score.txt)を与えられました。  
フォーマットは`名前 点数`になっています。  
この成績表から平均点を求めるプログラムを作ります。
```
nishio 90
yamada 68
shimizu 100
yoshioka 74
hosaka 28
```
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[100] = "score.txt";
  char buf[100];
  FILE* fp;
  int tmp, sum = 0, number = 0;
  double average;
  
  fp = fopen( filename, "r" );
  
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }
  
  while ( !feof( fp ) ) {
    fscanf( fp, "%s %d", buf, &tmp );
    number++;
    sum += tmp;
  }
  
  average = sum / number;
  printf("平均点: %f\n", average);
  fclose( fp );
  return 0;
}
```
## 8.6 演習問題
### 問題1
特になし
### 問題2
改行コードを見つけてあげるだけです。
```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
  char filename[100] = "out.txt";
  FILE* fp;
  int ch;
  int char_num = 0, line_num = 0;

  fp = fopen(filename, "r");
  if ( fp == NULL ) {
    printf("ファイルが開けませんでした\n");
    exit(1);
  }

  while ( !feof( fp ) ) {
    fgetc( fp );

    if ( (char)ch == '\n' ) {
      line_num++;
    }
    if ( (char)ch != '\n' ) {
      char_num++;
    }
  }

  printf("文字数: %d\n", char_num);
  printf("行数: %d\n", line_num);

  fclose(fp);
  return 0;
}
```
### 問題3
ソースファイルをreadして別ファイルにwriteするプログラム
### 問題4
一度tmpファイル作ってそっちに移してから交換するプログラム
