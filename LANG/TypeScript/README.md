## 型指定
```ts
const hello = (name: string) => {
    console.log('Hello,' + name + '!!!');
}
```
## インターフェース
```ts
interface Status {
    HP: number;
    Attack: number;
    Defense: number;
    Special: number;
    Speed: number;
}

const displayStatus(value: Status) {
    console.log(value.HP);
    console.log(value.Attack);
    console.log(value.Defense);
}
```
## クラス
```ts
class Pokemon {
    // フィールド
    name: string;
    Lv: number;
    HP: number;
    Attack: number;
    Defense: number;
    Special: number;
    Speed: number;
    
    // コンストラクタ
    constructor(Name: string, Lv: number, HP: number, Attack: number, Defense: number, Special: number, Speed: number) {
        this.Lv = Lv;
        this.HP = HP;
        this.Attack = number;
        this.Defense = Defense;
        this.Speed = Speed;
        this.Special = Special;
    }
}

let Pikachu = new Pokemon(
    Name = "ピカチュウ",
    Lv = 88,
    HP = 35,
    Attack = 55,
    Defense = 30,
    Speed = 90,
    Special = 50
)
```
