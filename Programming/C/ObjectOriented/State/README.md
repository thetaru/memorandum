# State
## ■ 概要
Stateパターンとは、「状態」をクラスとして表現するパターンです。  
ここでは、以下の状態遷移図を持つ有限状態機械(FSM)を実装します。

<div align="center">
  <img src="1.jpeg" alt="FSM">
</div>

## ■ 構成ファイル
|ファイル名|説明|
|:---|:---|
|FSM.h|FSMクラスを定義する|
|State.h|状態クラスを定義する|
|FSM.c|FSMクラスを実装する|
|State.c|状態クラスを実装する|
|SubState.c|サブ状態クラスを実装する|
|main.c|FSMクラスを使用するmain関数を記述する|
