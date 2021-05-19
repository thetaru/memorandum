# ファイルシステムにかかわるAPI
## 10.1 ディレクトリの内容を読む
ファイル1つの情報を持つ構造体のことをディレクトリエントリといいます。  
ディレクトリは、ディレクトリエントリの可変長配列と考えることができます。  
  
ディレクトリエントリのストリームを扱うAPIにも、普通のファイルを扱うAPIのopen()、read()、close()に対応する操作があります。
### ■ opendir(3)
```c
#include <sys/types.h>
#include <dirent.h>

DIR *opendir(const char *path);
```

|引数|意味|
|:---|:---|
|path|ディレクトリへのパス|

|戻り値|意味|
|:---|:---|
|成功|ディレクトリストリームへのポインタ|
|失敗|NULL|

opendir()は、ディレクトリパスpathにあるディレクトリを読み込みのために開きます。  
戻り値はDIRという型へのポインタで、これは構造体ストリームを管理するための構造体です。

### ■ readdir(3)
```c
#include <sys/types.h>
#include <dirent.h>

struct dirent *readdir(DIR *d);
```

|引数|意味|
|:---|:---|
|d|ディレクトリストリーム|

|戻り値|意味|
|:---|:---|
|成功|読み込んだエントリをdirent構造体で返す|
|失敗|NULL|

readdir()は、ディレクトリストリームdからエントリを1つ読み込みます。

### ■ closedir(3)
```c
#include <sys/types.h>
#include <dirent.h>

int closedir(DIR *d);
```

|引数|意味|
|:---|:---|
|d|ディレクトリストリーム|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

closedir()は、ディレクトリストリームdを閉じます。

### ■ lsコマンドを作る
```c
# FileName: ls.c
# ProgName: ls.o

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>

static void do_ls(char *path);

int main(int argc, char *argv[])
{
  int i;
  
  if (argc < 2) {
    fprintf(stderr, "%s: no arguments\n", argv[0]);
    exit(1);
  }
  for (i = 1; i < argc; i++) {
    do_ls(argv[i]);
  }
  exit(0);
}

static void do_ls(char *path)
{
  DIR *d;
  struct dirent *ent;
  
  d = opendir(path);
  if (!d) {
    perror(path);
    exit(1);
  }
  while (ent = readdir(d)) {
    printf("%s\n", ent->d_name);
  }
  closedir(d);
}
```

## 10.2 ディレクトリを作る
### ■ mkdir(2)
```c
#include <sys/stat.h>
#include <sys/types.h>

int mkdir(const char *path, mode_t mode);
```

|引数|意味|
|:---|:---|
|path|ディレクトリへのパス|
|mode|パーミッション|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

mkdir()は、ディレクトリパスを作成します。  
このシステムコールはかなり頻繁に失敗するためエラーとなる原因を挙げておきます。
- ENOENT
> 親ディレクトリがない
- ENOTDIR
> 親ディレクトリがディレクトリでない
- EEXIST
> すでに同名のファイルやディレクトリが存在する
- EPERM
> 親ディレクトリを変更する権限がない
### ■ umask
umaskはプロセスの属性の1つです。  
open()やmkdir()で指定したパーミッションは、`mode & ~umask`で計算されます。
```
mode   111 111 111
umask  000 010 010
-------------------
       111 101 101
```
### ■ umask(2)
```c
#include <sys/stat.h>
#include <sys/stat.h>

mode_t umask(mode_t mask);
```

|引数|意味|
|:---|:---|
|mask|umask|

|戻り値|意味|
|:---|:---|
|成功|直前のumaskの値|
|失敗|-|

umask()は、プロセスのumaskの値をmaskに変更します。

### ■ mkdirコマンドを作る
```c
### FileName: mkdir.c
### ProgName: mkdir.o

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
    int i;

    if (argc < 2) {
        fprintf(stderr, "%s: no arguments\n", argv[0]);
        exit(1);
    }
    for (i = 1; i < argc; i++) {
        if (mkdir(argv[i], 0777) < 0) {
            perror(argv[i]);
            exit(1);
        }
    }
    exit(0);
}
```

## 10.3 ディレクトリを削除する
### ■ rmdir(2)
```c
#include <unistd.h>

int rmdir(const char *path);
```

|引数|意味|
|:---|:---|
|path|ディレクトリへのパス|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

rmdir()は、ディレクトリパスpathを削除します。  
ただし、ディレクトリは空でなくてはいけません。

### ■ rmdirコマンドを作る
```c
### FileName: rmdir.c
### ProgName: rmdir.o

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  int i;
  
  if (argc < 2) {
    fprintf(stderr, "%s: no arguments\n", argv[0]);
    exit(1);
  }
  for (i = 1; i < argc; i++) {
    if (rmdir(argv[i]) < 0) {
      perror(argv[i]);
      exit(1);
    }
  }
  exit(0);
}
```

### ■ 10.4 ハードリンク
Linuxではファイルに2つ以上の名前を付けることができます。これをリンクといいます。  
ハードリンクは、ファイルの実体に紐づく名前です。  
つまり、ファイルの実体に対して複数の名前(ハードリンク)が紐づき、それぞれのハードリンクは直接的にファイルの実体へアクセスします。

### ■ link(2)
ハードリンクを作成するシステムコールがlink()です。
```c
#include <unistd.h>

int link(const char *src, const char *dest);
```

|引数|意味|
|:---|:---|
|src|ファイルの実体|
|dest|新しい名前(ハードリンク)|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

link()は、ファイルsrcの実体に新しい名前destをつけます。  
ただし、link()には次のような制約があります。
- srcとdestは同じファイルシステム上になければならない
> 名前と実体の対応を記録するためには両方が同一ファイルシステム上に存在しないといけないため
- srcとdestのどちらにもディレクトリは使えない
> つまりディレクトリには別名をつけることはできません。  
> この問題を回避するためにはシンボリックリンクを使います。

### ■ lnコマンドを作る
```c
### FileName: ln.c
### ProgName: ln.o

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  if (argc != 3) {
    fprintf(stderr, "%s: wrong arguments\n", argv[0]);
    exit(1);
  }
  if (link(argv[1], argv[2]) < 0) {
    perror(argv[1]);
    exit(1);
  }
  exit(0);
}
```

### ■ 10.5 シンボリックリンク
シンボリックは、ファイルの実体に既に紐づいているファイル名に紐づく名前です。  
つまり、ファイル名に対して複数の名前(シンボリックリンク)が紐づき、それぞれのシンボリックリンクはファイル名を通じて間接的にファイルの実体へアクセスします。
  
シンボリックリンクには次の特徴があります。
- シンボリックリンクには対応する実体が存在しなくてもよい
- ファイルシステムをまたいで別名を付けられる
- ディレクトリにも別名が付けられる

いずれもシンボリックリンクが直接実体にアクセスしないことで得られるメリットです。

### ■ symlink(2)
シンボリックリンクを作成するシステムコールはsymlink(2)です。
```c
#include <unistd.h>

int symlink(const char *src, const char *dest);
```

|引数|意味|
|:---|:---|
|src|ファイルの実体|
|dest|新しい名前(シンボリックリンク)|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

### ■ readlink(2)
```c
#include <unistd.h>

int readlink(const char *path, char *buf, size_t bufsize);
```

|引数|意味|
|:---|:---|
|path|シンボリックリンクへのパス|
|buf|バッファ|
|bufsize|バッファサイズ|

|戻り値|意味|
|:---|:---|
|成功|bufに格納したバイト数|
|失敗|-1|

readlink()は、シンボリックリンクへのパスpathが指す名前をbufに格納します。  
ただし、bufsizeバイトまでしか書き込めません。(そのため、bufsizeにはbufのサイズを渡すのが一般的です。)  
また、readlink()では文字列の最後にNULL文字'\0'が書き込まれないことに注意します。

### ■ symlinkコマンドを作る
```c
### FileName: symlink.c
### ProgName: symlink.o

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  if (argc != 3) {
    fprintf(stderr, "%s: wrong number of arguments\n", argv[0]);
    exit(1);
  }
  if (symlink(argv[1], argv[2]) < 0) {
    perror(argv[i]);
    exit(1);
  }
  exit(0);
}
```
