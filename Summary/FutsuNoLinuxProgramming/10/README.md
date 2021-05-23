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

## 10.4 ハードリンク
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

## 10.5 シンボリックリンク
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
    perror(argv[1]);
    exit(1);
  }
  exit(0);
}
```
## 10.6 ファイルを消す
### ■ unlink(2)
```c
#include <unistd.h>

int unlink(const char *path);
```

|引数|意味|
|:---|:---|
|path|リンクへのパス|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

unlink()は、ディレクトリは消せません。  
また、シンボリックリンクをunlink()するとシンボリックリンクだけが消えます。

### ■ rmコマンドを作る
```c
### rm.c
### rm.o

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
    if (unlink(argv[i]) < 0) {
      perror(argv[i]);
      exit(1);
    }
  }
  exit(0);
}
```

## 10.7 ファイルを移動する
Linuxにおいて「ファイルを移動する」ことは、ディレクトリ配列の要素であるディレクトリエントリを他のディレクトリ配列へ移すことに等しいです。  
つまり、別のハードリンクを作ってから元の名前を消すとも言えます。
### ■ rename(2)
ファイルを移動するAPIは、rename()です。
```c
#include <stdio.h>

int rename(const char *src, conat char *dest);
```

|引数|意味|
|:---|:---|
|src|ファイル名|
|dest|ファイル名|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

rename()は、ファイル名srcをファイル名destに変更します。  
ただし、ファイルシステムをまたいで移動することはできません。

### ■ mvコマンドを作る
```c
### FileName: mv.c
### ProgName: mv.o

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  if (argc != 3) {
    fprintf(stderr, "%s: wrong arguments\n", argv[0]);
    exit(1);
  }
  if (rename(argv[1], argv[2]) < 0) {
    perror(argv[1]);
    exit(1);
  }
  exit(0);
}
```

## 10.8 付帯情報を得る
ファイルシステムにはデータ本体の他にも色々な情報も格納されています。  
この情報を得るシステムコールがstat()とlstat()です。
### ■ stat(2)
```c
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int stat(const char *path, struct stat *buf);
int lstat(const char *path, struct stat *buf);
```

|引数|意味|
|:---|:---|
|path|オブジェクトへのパス|
|buf|バッファ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

stat()は、pathで表されるエントリの情報を取得し、bufに書き込みます。  
lstat()もstat()とほとんど同じですが、pathがシンボリックリンクのときはシンボリックリンク自身の情報を返します。  
  
Linuxのstruct stat型の内容を以下に示します。
|型|メンバ名|説明|
|:---|:---|:---|
|dev_t|st_dev|デバイス番号|
|ino_t|st_info|iノード番号|
|mode_t|st_mode|ファイルタイプとパーミッションを含むフラグ|
|nlink_t|st_nlink|リンクカウント|
|uid_t|st_uid|所有ユーザID|
|gid_t|st_gid|所有グループID|
|dev_t|st_rdev|デバイスファイルの種別を表す番号|
|off_t|st_size|ファイルサイズ(バイト単位)|
|blksize_t|st_blksize|ファイルのブロックサイズ|
|blkcnt_t|st_blocks|ブロック数|
|time_t|st_atime|最終アクセス時刻|
|time_t|st_mtime|最終更新時刻|
|time_t|st_ctime|付帯情報が最後に変更された時刻|

### ■ statコマンドを作る
```c
### FileName: stat.c
### ProgName: stat.o

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>

static char *filetype(mode_t mode);

int main(int argc, char *argv[])
{
  struct stat st;
  
  if (argc != 2) {
    fprintf(stderr, "wrong arguments\n");
    exit(1);
  }
  if (lstat(argv[1], &st) < 0) {
    perror(argv[1]);
    exit(1);
  }
  printf("type\t%o (%s)\n", (st.st_mode & S_IFMT), filetype(st.st_mode));
  printf("mode\t%o\n", st.st_mode & ~S_IFMT);
  printf("dev\t%llu\n", (unsigned long long)st.st_dev);
  printf("ino\t%lu\n", (unsigned long)st.st_ino);
  printf("rdev\t%llu\n", (unsigned long long)st.st_rdev);
  printf("nlink\t%d\n", st.st_nlink);
  printf("uid\t%d\n", st.st_uid);
  printf("gid\t%d\n", st.st_gid);
  printf("size\t%ld\n", st.st_size);
  printf("blksize\t%lu\n", (unsigned long)st.st_blksize);
  printf("blicks\t%lu\n", (unsigned long)st.st_blocks);
  printf("atime\t%s", ctime(&st.st_atime));
  printf("mtime\t%s", ctime(&st.st_mtime));
  printf("ctime\t%s", ctime(&st.st_ctime));
  exit(0);
}

static char* filetype(mode_t mode)
{
  if (S_ISREG(mode)) return "file";
  if (S_ISDIR(mode)) return "directory";
  if (S_ISCHR(mode)) return "chardev";
  if (S_ISBLK(mode)) return "blickdev";
  if (S_ISFIFO(mode)) return "fifo";
  if (S_ISLNK(mode)) return "symlink";
  if (S_ISSOCK(mode)) return "socket";
  return "unknown";
}
```
やっていることは明快です。  
st_modeメンバからファイル種類を取り出すためにビットマスクS_IFMTと、ファイルの種類を判定するためのS_ISREG()などのマクロを使っています。  

|マクロ名|説明|
|:---|:---|
|S_ISREG|普通のファイルなら非ゼロ|
|S_ISDIR|ディレクトリなら非ゼロ|
|S_ISLNK|シンボリックリンクなら非ゼロ|
|S_ISCHR|キャラクタデバイスなら非ゼロ|
|S_ISBLK|ブロックデバイスなら非ゼロ|
|S_ISFIFO|名前付きパイプ(FIFO)なら非ゼロ|
|S_ISSOCK|UNIXソケットなら非ゼロ|

## 10.9 付帯情報を変更する
### ■ chmod(2)
```c
#include <sys/types.h>
#include <sys/stat.h>

int chmod(const char *path, mode_t mode);
```

|引数|意味|
|:---|:---|
|path|ファイルへのパス|
|mode|ファイルのモード|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

chmod()は、ファイルpathのモードをmodeに変更します。  
modeは定数のビットごとのORを使うか、数値を指定します。

|定数|値|意味|
|:---|:---|:---|
|S_IRUSR、S_IREAD|00400|所有ユーザから読み込み可能|
|S_IWUSR、S_IWRITE|00200|所有ユーザから書き込み可能|
|S_IXUSR、S_IEXEC|00100|所有ユーザから実行可能|
|S_IRGRP|00040|所有グループから読み込み可能|
|S_IWGRP|00020|所有グループから書き込み可能|
|S_IXGRP|00010|所有グループから実行可能|
|S_IROTH|00004|それ以外のユーザから読み込み可能|
|S_IWOTH|00002|それ以外のユーザから書き込み可能|
|S_IXOTH|00001|それ以外のユーザから実行可能|

### ■ chown(2)
```c
#include <sys/types.h>
#include <unistd.h>

int chown(const char *path, uid_t owner, gid_t group);
int lchown(const char *path, uid_t owner, gid_t group);
```

|引数|意味|
|:---|:---|
|path|ファイルへのパス|
|owner|ファイルの所有ユーザ|
|group|ファイルの所有グループ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

chown()は、ファイルpathの所有ユーザをownerに、所有グループをgroupに変更します。  
ownerにはユーザID(UID)、groupにはグループID(GID)を指定します。  
UIDかGIDのどちらか一方を変更したい場合は、変更したくないほうに-1を指定します。  
  
lchown()は、chown()とほぼ同じですが、pathがシンボリックリンクだった場合にそのシンボリックリンク自体の情報を変更します。  
※ chown()はシンボリックリンクの指すファイルの情報を変更します。
### ■ utime(2)
```c
#include <sys/types.h>
#include <utime.h>

int utime(const char *path, struct utimbuf *buf);

struct utimbuf {
  time_t actime;    /* 最終アクセス時刻 */
  time_t modtime;  /* 最終更新時刻 */
}
```

|引数|意味|
|:---|:---|
|path|ファイルへのパス|
|buf|バッファ|

|戻り値|意味|
|:---|:---|
|成功|0|
|失敗|-1|

utime()は、ファイルpathの最終アクセス時刻(st_atime)と最終更新時刻(st_mtime)を変更します。  
bufがNULLでない場合、最終アクセス時刻をbuf->actimeに、最終更新時刻をbuf->modtimeにそれぞれ変更します。  
bufがNULLの場合、両方を現在の時刻に変更します。

### ■ chmodコマンドを作る
```c
### FileName: chmod.c
### ProgName: chmod.o

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(int argc, char *argv[])
{
  int mode;
  int i;
  
  if (argc < 2) {
    fprintf(stderr, "no mode given\n");
    exit(1);
  }
  mode = strtol(argv[1], NULL, 8);
  for (i = 2; i < argc; i++) {
    if (chmod(argv[i], mode) < 0) {
      perror(argv[i]);
    }
  }
  exit(0);
}
```

## 10.10 ファイルシステムとストリーム
書籍参照

## 10.11 練習問題
### 1
コマンドライン引数で指定されたディレクトリ以下を再帰的にトラバースして見つかったファイルのパスをすべて表示するプログラムを書きなさい。(ただし、シンボリックリンクをたどってはいけません)  
※ 再帰関数で実装したい。
```c
```
参考: https://craftofcoding.wordpress.com/2020/04/02/writing-a-recursive-ls-in-c/
