# grepコマンドを作る
## 8.1 grepコマンドを作る
### ■ 基本的な正規表現
正規表現の説明についてなので省きます。

### ■ grepコマンドの概略
今回は、一文字ずつ読み込むと正規表現にマッチするかどうか判断できないため一行をバッファに読み込む必要があります。  
正規表現はlibcのAPIを使うことで扱えるようになります。

### ■ コードの解説
やっていることは難しくないので省略します。  

## 8.2 日本語文字列処理と国際化
特にいうことはない

## 8.3 練習問題
### 1 自作grepコマンドにiオプションとvオプションを実装する
```c
### FileName: grep.c
### ProgNmae: grep.o

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>

#define _GNU_SOURCE
#include <getopt.h>

#define isIgnore 1
#define isInvert 2
unsigned int flag = 0;

static void do_grep(regex_t *pat, FILE *f);

int main(int argc, char *argv[])
{
   regex_t pat;
   int err;
   int i;

   int opt;

   while ((opt = getopt(argc, argv, "iv")) != -1) {
       switch (opt) {
       case 'i':
           flag |= isIgnore;
           break;
       case 'v':
           flag |= isInvert;
           break;
       case '?':
           fprintf(stderr, "ERR\n");
           exit(1);
       }
   }

   if (argc < 2) {
       fputs("no pattern\n", stderr);
       exit(1);
   }
   if (flag & isIgnore) {
       err = regcomp(&pat, argv[optind], REG_EXTENDED | REG_NOSUB | REG_NEWLINE | REG_ICASE);
   } else {
       err = regcomp(&pat, argv[optind], REG_EXTENDED | REG_NOSUB | REG_NEWLINE);
   }
   if (err != 0) {
       char buf[1024];

       regerror(err, &pat, buf, sizeof buf);
       puts(buf);
       exit(1);
   }

   if (optind == argc) {
       do_grep(&pat, stdin);
   } else {
       for (i = optind + 1; i < argc; i++) {
           FILE *f;

           f = fopen(argv[i], "r");
           if (!f) {
               perror(argv[i]);
               exit(1);
           }
           do_grep(&pat, f);
           fclose(f);
       }
   }
   regfree(&pat);
   exit(0);
}

static void do_grep(regex_t *pat, FILE *src) {
    char buf[2048];

    while (fgets(buf, sizeof buf, src)) {
        if (flag & isInvert) {
            if (regexec(pat, buf, 0, NULL, 0) != 0) {
                fputs(buf, stdout);
            }
        } else {
            if (regexec(pat, buf, 0, NULL, 0) == 0) {
                fputs(buf, stdout);
            }
        }
    }
}
```
### 2 難) grepコマンドが扱える行の長さの制限をなくす(第11章を読んでから取り組むこと)
