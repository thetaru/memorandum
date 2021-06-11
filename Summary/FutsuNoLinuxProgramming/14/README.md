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
```
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
