# 構造体
## 7.1 構造体
構造体とは、複数の変数をまとめたものです。
#### Syntax - 構造体
```c
struct 構造体の名前 {
  構造体の中身
}
```
構造体を使ったプログラムを見てみます。
```c
#include <stdio.h>

#define NUMBER_OF_STUDENT 3

struct Student {
  char student_name[100];
  int student_age;
};

int main(void)
{
  struct Student st[NUMBER_OF_STUDENT];
  int i;
  int num;
  printf("%d人の生徒の情報を入力してください\n", NUMBER_OF_STUDENT);
  
  for ( i=0; i < NUMBER_OF_STUDENT; i++ ) {
    printf("%d人目の名前: ", i+1);
    scanf("%s", st[i].student_name);
    printf("%d人目の年齢: ", i+1);
    scanf("%d", &st[i].student_age);
  }
  
  for (;;) {
    printf("何人目の生徒の情報が見たいですか: ");
    scanf("%d", &num);
    
    if ( num > NUMBER_OF_STUDENT || num <= 0 ) {
      printf("終了します\n");
      break;
    } else {
      printf("名前: %s, 年齢: %d\n", st[num-1].student_name, st[num-1].student_age);
    }
  }
  return 0;
}
```
`struct Student st[NUMBER_OF_STUDENT]`で Student という構造体の配列を定義しています。  
`typedef`を使い次のように宣言すると、構造体の名前をStudentにできます。
```c
#include <stdio.h>

#define NUMBER_OF_STUDENT 3

/* 変更点 */
typedef struct Student_tag {
  char student_name[100];
  int student_age;
} Student;

int main(void)
{
  Student st[NUMBER_OF_STUDENT];
  int i;
  int num;
  printf("%d人の生徒の情報を入力してください\n", NUMBER_OF_STUDENT);
  
  for ( i=0; i < NUMBER_OF_STUDENT; i++ ) {
    printf("%d人目の名前: ", i+1);
    scanf("%s", st[i].student_name);
    printf("%d人目の年齢: ", i+1);
    scanf("%d", &st[i].student_age);
  }
  
  for (;;) {
    printf("何人目の生徒の情報が見たいですか: ");
    scanf("%d", &num);
    
    if ( num > NUMBER_OF_STUDENT || num <= 0 ) {
      printf("終了します\n");
      break;
    } else {
      printf("名前: %s, 年齢: %d\n", st[num-1].student_name, st[num-1].student_age);
    }
  }
  return 0;
}
```
こうすることで構造体を型のように扱えます。
## 7.4 例題
### 7.4.1 2点間の距離を求めるプログラム
```c
#include <stdio.h>
#include <math.h>

typedef struct Point_tag {
  double x;
  double y;
} Point;

int main(void)
{
  Point p1, p2;
  double distance;

  printf("p1の(x,y)座標を入力: ");
  scanf("%lf %lf", &p1.x, &p1.y);
  
  printf("p2の(x,y)座標を入力: ");
  scanf("%lf %lf", &p2.x, &p2.y);

  distance = sqrt( (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y) );
  printf("2点間の距離: %f\n", distance);
  return 0;
}
```
math.hをインクルードするのでコンパイルする際は`lm`オプションを付けましょう。
