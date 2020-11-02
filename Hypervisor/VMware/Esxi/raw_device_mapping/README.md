# Raw Device Mapping(RDM)
VMの仮想ディスクの**参照先を仮想ディスクのvmdkファイルでなく、物理HDDにする**ってわけ。  
(正確には物理互換のRDMと仮想互換のRDMとで異なる)  
ESXi本体が壊れても物理HDDを引っこ抜いて他端末に認識させれば救済可能できる。  

|OS|バージョン|
|:---|:---|
|ESXi|6.7|

## ■ ディスク識別子の確認
VMの参照先に指定する物理HDDの識別子を確認します。
### コマンドで確認する方法
```
# ls -l /vmfs/devices/disks
```
### vSphere Web Client上から確認する方法
「ストレージ」-「デバイス」よりHDDを選択し**パス情報**から確認できます。
## ■ マッピングファイルの保存先
```
### 物理互換
# vmkfstools -z <対象HDDのパス情報> </vmfs/volumes/<任意のパス>/rdm_disk.vmdk>

### 仮想互換
# vmkfstools -r <対象HDDのパス情報> </vmfs/volumes/<任意のパス>/rdm_disk.vmdk>
```
## ■ VMへの割り当て
「設定の編集」-「ハードディスクの追加」-「既存のハードディスク」より作成したvmdkを選択して割り当てます。 
