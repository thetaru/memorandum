# 1.2 静的解析をやってみよう
## ■ 静的解析と動的解析
ソフトウェアを解析する手法は大きく`静的解析`と`動的解析`の2つに分けられる。
- 静的解析
> 対象となるプログラムを実行せずに解析する
- 動的解析
> 対象となるプログラムを実行しながら解析する

1.1章でsample_mal.exeに対して行った手法は動的解析である。  
静的解析では以下のような手法となる。
- 逆アセンブルしたコードを読む
- 実行ファイルの中から文字列を抽出し、どのような単語が使われるか調べる

それでは、`chap01\wsample01a\Release`にあるサンプルプログラム`wsample01a.exe`を静的解析していく。  

## ■ バイナリエディタでファイルの中身を眺めてみる
バイナリエディタ(Stirlingを使うこととする)でwsample01a.exeを開く。
  
![1-2-1](./images/1-2-1.png)
  
Stirlingでwsample01a.exeを開くと、16進数のバイト列が表示される。  
これはPEフォーマットといい、Windowsの実行ファイル形式にならったデータ列である。  
  
ざっと読んでみると、色々な文字列(例えば、Helloやファイルパス、モジュール名など)が見けることができる。

## ■ アセンブラを読めなくても解析はできる
次は、wsample01a.exeをIDA Freeware(version 7.6)を使って逆アセンブルしていく。  
IDAのアイコンへwsample01a.exeをドラッグすると次のような画面が表示される。  
  
![1-2-2](./images/1-2-2.png)
  
![1-2-3](./images/1-2-3.png)
  
画面左側のFunctionsというウィンドウの一番上(sub_401000)をダブルクリックすると、逆アセンブルされたコードがIDA View-Aウィンドウに表示される。
  
![1-2-4](./images/1-2-4.png)
    
なお、表示形式を右クリックして表示されるメニューから`Text view`もしくは`Graph view`を選択することで変えることができる。

## ■ ソースコードがない状態から動作を把握する
sub_401000関数内の処理を眺めていると、`Hello! Windows`、`MESSAGE`、`MessageBoxW`といった文字列の他にも、以下の文字列が見つかる。
- 2012
- lstrcmpW
- GetActiveWindow

文字列`Hello! Windows`と`Hello! 2012`が分岐したところに表示されていることに注目する。  
ためしに、コマンドプロンプトから、2012という文字列を引数に渡して、wsample01a.exeを実行する。
```
C:\> wsample01a.exe 2012
```
すると、引数を渡さずに実行した場合は`Hello! Windows`を表示し、引数に2012を渡して実行した場合は`Hello! 2012`と表示されることが分かる。  
  
以下は、wsample01a.exeのアセンブルコードである。
```
00401000 sub_401000      proc near               ; CODE XREF: start-138↓p
00401000
00401000 arg_8           = dword ptr  10h
00401000
00401000                 push    ebp
00401001                 mov     ebp, esp
00401003                 mov     eax, [ebp+arg_8]
00401006                 push    offset a2012    ; "2012"
0040100B                 push    eax
0040100C                 call    ds:lstrcmpW
00401012                 push    0
00401014                 push    offset aMessage ; "MESSAGE"
00401019                 test    eax, eax
0040101B                 jnz     short loc_401035
0040101D                 push    offset aHello2012 ; "Hello! 2012"
00401022                 call    ds:GetActiveWindow
00401028                 push    eax
00401029                 call    ds:MessageBoxW
0040102F                 xor     eax, eax
00401031                 pop     ebp
00401032                 retn    10h
00401035 ; ---------------------------------------------------------------------------
00401035
00401035 loc_401035:                             ; CODE XREF: sub_401000+1B↑j
00401035                 push    offset aHelloWindows ; "Hello! Windows"
0040103A                 call    ds:GetActiveWindow
00401040                 push    eax
00401041                 call    ds:MessageBoxW
00401047                 xor     eax, eax
00401049                 pop     ebp
0040104A                 retn    10h
0040104A sub_401000      endp
```

## ■ 逆アセンブルされたソースコードを確認する
最後に、wsample01a.exeのソースコード(`chap01\wsample01a\wsample01.cpp`)も確認する。
```cpp
#include <Windows.h>
#include <tchar.h>

int APIENTRY _tWinMain(
	HINSTANCE hInstance, 
	HINSTANCE hPrevInstance, 
	LPTSTR    lpCmdLine, 
	int       nCmdShow)
{
	if(lstrcmp(lpCmdLine, _T("2012")) == 0){
		MessageBox(GetActiveWindow(), 
			_T("Hello! 2012"), _T("MESSAGE"), MB_OK);
	}else{
		MessageBox(GetActiveWindow(), 
			_T("Hello! Windows"), _T("MESSAGE"), MB_OK);
	}	
	return 0;
}
```
ざっと見てみると逆アセンブルされたコードと似た個所が数か所見て取れる。
