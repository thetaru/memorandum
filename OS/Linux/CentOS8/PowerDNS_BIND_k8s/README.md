# PowerDNS+BIND+k8sでDNSを構築する
## ■ 前提条件
オンプレ環境を想定して実施する。  
また、k8sが構築済みかつhelmやMetalLBが導入済みでことを仮定する。
## ■ 構成
PowerDNSをマスター、BINDをスレーブとした構成とする。   
  
PowerDNSへの名前解決は不許可とし、BINDへの名前解決のみを許可する。  
つまり、PowerDNSはレコード登録用のコントローラとして使用される。  
  
PowerDNSには、webインターフェースを使用するためにPowerDNS-Adminを導入する。
