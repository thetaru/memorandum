# メモリ管理とファイル入出力
## 8.1 動的メモリ割り当て
### 8.1.1 malloc関数とfree関数
C言語には動的メモリ割り当てを行える`malloc`という関数があります。    
malloc関数はstdlib.hに定義されています。  
そのためstring.hをインクルードする必要があります。
#### Syntax - malloc
```c
ポインタ変数 = malloc( メモリバイト数 );
```
malloc関数はメモリバイト数で割り当てた領域の先頭を指すポインタを返します。  
メモリの割り当てに失敗した場合はNULLポインタが返ってきます。  
  
割り当てたメモリはプログラムが終了するまで確保されますが、メモリが不要になった場合に自分で開放してやる必要があります。  
メモリの開放にはfree関数を使用します。
#### Syntax - free
```c
free( ポインタ変数 );
```
  
実際にint型の要素数5の配列を宣言してみます。
```c
int *p;
p = (int*)malloc( 4 * 5 );
```
int型のサイズを4byteとして　5要素分のメモリ領域(= 4\*5 = 20byte)を確保します。  
上の場合は解説のしやすさからint型を4byteとしましたが、実際の場合は次のように`sizeof`を使って型のサイズを取得しましょう。
```c
int *p;
p = (int*)malloc( sizeof(int) * 5 );
```
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
```
