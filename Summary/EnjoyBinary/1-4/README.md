# 1.4 最低限のアセンブラ命令だけざっくり把握する
## ■ すべてのアセンブラ命令を覚える必要はない
よく使われるアセンブラ命令
|命令|例|意味|説明|
|:---|:---|:---|:---|
|MOV|MOV EAX,ECX|EAX = ECX||
|ADD|ADD EAX,ECX|EAX += ECX||
|SUB|SUB EAX,ECX|EAX -= ECX||
|INC|INC EAX|EAX++||
|DEC|DEC EAX|EAX--||
|LEA|LEA EAX,[ECZ+4]|EAX = ECX+4||
|CMP|CMP EAX,ECX|if(EAX == ECZ)</br>||
|TEST|TEST EAX,EAX|||
|JE(JZ)|JE 04001000|||
|JNE(JNZ)|JNE 04001000|||
|JMP|JMP 04001000|||
|CALL|CALL lstrcmpW|||
|PUSH|PUSH 00000001|||
|POP|POP EAX|||
