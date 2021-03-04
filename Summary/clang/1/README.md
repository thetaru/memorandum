# 1.1 コンパイラ
特になし
# 1.2 開発環境を整える
特になし
# 1.3 画面に文字を表示する
## 1.3.1 プログラムを作る前に
特になし
## 1.3.2 Hello World プログラム
次のソースコードを書きます。
```c
#include <stdio.h>
int main(void)
{
  printf("Hello World!");
  return 0;
}
```
コンパイルして実行したら画面上に"Hello World!"と表示されたら成功です。
```
$ gcc main.c -o main.o
```

```
$ ./main.o
```
```
Hello, World
```
