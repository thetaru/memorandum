# プロセスにかかわるAPI
## 12.1 　基本的なプロセスAPI
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

### ■ exec
```c
#include <unistd.h>

int execl(const char *path, const char *arg0, ... /* NULL */);
int execv(const char *path, char *const argv[]);
```

|引数|意味|
|:---|:---|
|path|プログラムへのパス|
|第2引数以降|コマンドライン引数|

|戻り値|意味|
|:---|:---|
|成功|-|
|失敗|-1|

execは、自プロセスを新しいプログラムで上書きするシステムコールです。  
execを実行すると、その時点で実行しているプログラムが消失し、自プロセス上に新しいプログラムをロードします。  
イメージとしては、プロセス上にもともとあるプログラムを新しいプログラムに上書きする感じです。  
  
#### 使用例
```c
/* execl()の使用例 */
execl("/bin/cat", "cat", "hello.c", NULL);

/* execv()の使用例 */
char *argv[3] = { "cat", "hello.c", NULL };
execv("/bin/cat", argv);
```

### ■ wait(2)
```c
#include <sys/types.h>
#include <sys/wait.h>

pid_t wait(int *status);
pid_t waitpid(pid_t pid, int *status, int options);
```
