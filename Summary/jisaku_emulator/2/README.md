# 2.1 レジスタ
レジスタは、CPUに組み込まれている作業用領域のことです。  
アセンブリ言語の命令で何らかのデータを扱う際、ほとんどの場合にレジスタを指定できます。  
※ 命令によっては、暗黙的に特定のレジスタがデータの読み込み元・書き込み先として固定されている場合があります。  
  
アセンブリ言語ではレジスタを直接扱いますが、C言語からレジスタを扱うことはできません。  
C言語では変数という名前で抽象化され、Cコンパイラが必要に応じてレジスタを操作するアセンブリ言語命令を出力します。  
  
# 2.2 メモリ
メモリは、CPUの外側に接続されている部品です。  
データを記憶するという機能はレジスタと同じですが、レジスタより容量も大きいです。(eaxレジスタが4バイトなのに対し、数GBのメモリが搭載されています)
```
+--------------------------------------+                                 +--------------+
|                  CPU                 |                                 |              |
|    +---------+        +---------+    |             Address             |              |
|    |   eax   |        |   esp   |    | ------------------------------> |              |
|    +---------+        +---------+    |                                 |              |
|    +---------+        +---------+    |                                 |              |
|    |   ecx   |        |   ebp   |    |                                 |              |
|    +---------+        +---------+    |                                 |    Memory    |
|    +---------+        +---------+    |                                 |              |
|    |   edx   |        |   esi   |    |                                 |              |
|    +---------+        +---------+    |                                 |              |
|    +---------+        +---------+    |               data              |              |
|    |   ebx   |        |   edi   |    | <-----------------------------> |              |
|    +---------+        +---------+    |                                 |              |
+--------------------------------------+                                 +--------------+
     レジスタはCPU内部にあります。                                      メモリはCPU外部にあります。
           SRAMなので速いです。                                           DRAMなので遅いです。
```
CPUは大きな記憶領域(メモリ)に対し、メモリの先頭から1バイトずつ振られた連番を使ってアクセスします。  

## 例1
メモリの0x7c00番地から0x7c03番地の4バイトのデータを0x7a00番地から0x7a03番地の領域にコピーするには
```asm
mov eax, [0x7c00]
mov [0x7a00], eax
```
また、こんな書き方もできます。
```asm
mov ebx, 0x7a00
mov eax, [ebx+0x200]
mov [ebx], eax
```
0x7a00と0x7c00がメモリ番地であることをアセンブラに伝えるには、それぞれ`[]`で囲みます。

## 例2
以下のソースコードをアセンブルするとlea命令という命令があることがわかります。  
この命令は、指定されたメモリ番地を計算し、その結果の番地をレジスタに書き込みます。
```c
void func(void)
{
  int val;
  int *ptr = &val;
  *ptr = 41;
}
```
```asm
                        ; void func(void) {
push ebp
mov ebp,esp
sub esp,16

                        ; int val;
                        ; int *ptr = &val;
lea eax,[ebp-0x8]       ; 変数val([ebp-8])の番地がeaxに格納されます
mov [ebp-0x4],eax       ; eaxの値が変数ptr([ebp-4])に格納されます

                        ; *ptr = 41;
mov eax,[ebp-0x4]       ; 変数ptrの値をeaxに読み出してから、
mov dword [eax],0x29    ; eaxの値で示される4バイトのメモリ領域に41を書き込みます

                        ; }
leave
ret
```
レジスタはeax、ebpのように名前で指定するのに対し、メモリは[ebp-4]のように番地を使って指定します。  
アセンブリ言語ではレジスタは名前で、メモリは番地でその場所を表します。

# 2.3 初めてのエミュレータ
データの演算装置(加算器や論理演算器など)は、エミュレータが動くパソコンのCPUの演算装置をそのまま使います。  
※ つまり、加算`+`や論理積`&`は流用します  
  
まず、エミュレータ本体を表す構造体Emulatorを定義します。  
この中でeipやeflagsはCPUの特殊なレジスタを表します。  
※ eipは、実行中の機械語が置かれてあるメモリ番地を記憶するレジスタです
```c
typedef struct {
  /* 汎用レジスタ */
  uint32_t registers[REGISTERS_COUNT];
  
  /* EFLAGSレジスタ */
  uint32_t eflags;
  
  /* メモリ(バイト列) */
  uint8_t* memory;
  
  /* プログラムカウンタ */
  uint32_t eip;
} Emulator;
```
次に、create_emuでエミュレータ構造体を生成と初期化をした後、機械語ファイルを開きemu->memoryに読み取ります。  
※ コマンドライン引数に機械語プログラムが格納されたファイルを指定する仕様としました。
```c
/* エミュレータを作成する */
Emulator* create_emu(size_t size, uint32_t eip, uint32_t esp)
{
    Emulator* emu = malloc(sizeof(Emulator));
    emu->memory = malloc(size);

    /* 汎用レジスタの初期値をすべて0にする */
    memset(emu->registers, 0, sizeof(emu->registers));
    
    /* レジスタの初期値を指定されたものにする */
    emu->eip = eip;
    emu->registers[ESP] = esp;

    return emu;
}

/* エミュレータを破棄する */
void destroy_emu(Emulator* emu)
{
    free(emu->memory);
    free(emu);
}

int main(int argc, char *argv[])
{
    FILE *binary;
    Emulator* emu;

    if (argc != 2) {
        printf("usage: px86 filename\n");
        return 1;
    }

    /* EIPが0、ESPが0x7C00の状態のエミュレータを生成する */
    emu = create_emu(MEMORY_SIZE, 0x0000, 0x7c00);

    binary = fopen(argv[1], "rb");
    if (binary == NULL) {
        printf("%sファイルが開けません\n", argv[1]);
        return 1;
    }

    /* 機械語ファイルを読み込む(最大512バイト) */
    fread(emu->memory, 1, 0x200, binary);
    fclose(binary);

    destroy_emu(emu);
    return 0;
}
```
次はエミュレータが機械語を実行する部分を作ります。  
`emu->memory[emu->eip]`から1バイト(つまり命令のオペコード部分)を読み取り、その値によって処理を振り分けます。  
この処理には関数ポインタテーブルinstructionsを利用します。  
  
関数ポインタテーブルは、おおざっぱに言うと関数を登録するための配列です。  
オペコードの値を添え字に指定すると、そのオペコードに対応する処理を行う関数を呼び出します。
```c
void mov_r32_imm32(Emulator* emu)
{
    uint8_t reg = get_code8(emu, 0) - 0xB8;
    uint32_t value = get_code32(emu, 1);
    emu->registers[reg] = value;
    emu->eip += 5;
}

void short_jump(Emulator* emu)
{
    /* オペランドを8ビット符号付き整数としてdiffに読み込む */
    int8_t diff = get_sign_code8(emu, 1);
    /* 次の命令の番地を基点にジャンプ先を計算する */
    /* ショートジャンプは2バイト命令のため、eipにdiff+2を格納する */
    emu->eip += (diff + 2);
}

typedef void instruction_func_t(Emulator*);
instruction_func_t* instructions[256];
void init_instructions(void)
{
    int i;
    memset(instructions, 0, sizeof(instructions));
    for (i = 0; i < 8; i++) {
        instructions[0xB8 + i] = mov_r32_imm32;
    }
    instructions[0xEB] = short_jump;
}

int main(int argc, char* argv[])
{
    /* 中略 */
    init_instructions();

    while (emu->eip < MEMORY_SIZE) {
        uint8_t code = get_code8(emu, 0);
        /* 現在のプログラムカウンタと実行されるバイナリを出力する */
        printf("EIP = %X, Code = %02X\n", emu->eip, code);

        if (instructions[code] == NULL) {
            /* 実装されてない命令が来たらVMを終了する */
            printf("\n\nNot Implemented: %x\n", code);
            break;
        }

        /* 命令の実行 */
        instructions[code](emu);

        /* EIPが0になったらプログラム終了 */
        if (emu->eip == 0x00) {
            printf("\n\nend of program.\n\n");
            break;
        }
    }

    dump_registers(emu);
    destroy_emu(emu);
    return 0;
}
```
1つの命令を実効するたびにeipをチェックし、0ならメインループを終了させることにしました。  
普通のCPUには終了機能はありませんが、エミュレータではプログラムの終了後にレジスタの値を表示させたいので、明示的に終了させる仕組みが必要になります。  
また、eipを0にするには、単に0番地へのジャンプ命令をすればOKです。  

### mov_r32_imm32
mov_r32_imm32は汎用レジスタに32ビットの即値をコピーするmov命令に対応します。  
このmov命令のオペコードは、`r`をレジスタ番号とすると0xB8+rとなります。  
オペコード自身がレジスタの指定を含むタイプの命令です。  
オペコードのすぐ後に32ビットの即値がくるはずなので、get_code32で32ビット値を読み取ってレジスタに代入します。  

### short_jump
short_jumpは1バイトのメモリ番地を取るjmp命令、ショートジャンプ命令に対応します。  
この命令はオペランドに1バイトの符号付き整数を取り、eipに加算します。  
したがって、現在地から前に127バイト、後ろに128バイトの範囲内でジャンプすることができます。  

### その他
get_code8やget_sign_code8、get_code32はmemory配列の指定した番地から8ビットや32ビットの値を取得する関数です。  
関数の第二引数にそのときのeipからのオフセットを指定すると、その番地から値を読み取って返します。  
```c
uint32_t get_code8(Emulator* emu, int index)
{
    return emu->memory[emu->eip + index];
}

int32_t get_sign_code8(Emulator* emu, int index)
{
    return (int8_t)emu->memory[emu->eip + index];
}

uint32_t get_code32(Emulator* emu, int index)
{
    int i;
    uint32_t ret = 0;

    /* リトルエンディアンでメモリの値を取得する */
    for (i = 0; i < 4; i++) {
        ret |= get_code8(emu, index + i) << (i * 8);
    }

    return ret;
}
```
一通り説明したので、エミュレータの動作確認を兼ねて簡単なアセンブリ言語プログラムを作り、動作させます。  
エミュレータに実装した命令は、即値をレジスタに書き込むmov命令とショートジャンプのjmp命令なので、次のようなプログラムを動かせるはずです。
```asm
BITS 32
start:
  mov eax, 41
  jmp short start
```
`BITS 32`はアセンブラNASMに対して32ビットモードでアセンブルすることを伝えます。  
その次のstartはラベルで、その地点のメモリ番地に名前を付ける役割があります。  
このプログラムは先頭を0番地としてアセンブル・リンクされることを前提にしており、そのときにstartラベルは0番地になります。  
  
実際にエミュレータで動かすために、プログラムとエミュレータ本体をビルドしましょう。  
まず、コンパイル・リンクして実行ファイルを生成します。(使用するMakefileはMakefile_helloworld)
```
# make
```
次に、エミュレータをコンパイルして実行ファイルpx86を生成します。(使用するMakefileはMakefile_emu2.3)
```
# make
```
最後に、エミュレータを実行します。
```
# ./px86 helloworld.bin
```
```
EIP = 0, Code = B8
EIP = 5, Code = EB


end of program.

EAX = 00000029
ECX = 00000000
EDX = 00000000
EBX = 00000000
ESP = 00007c00
EBP = 00000000
ESI = 00000000
EDI = 00000000
EIP = 00000000
```
eaxレジスタが0x00000029となっていれば成功です。
