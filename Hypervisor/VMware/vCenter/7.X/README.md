# vCenter 7.X
## 注意1
名前解決が必要なesxiとvCenter自信の名前解決が必須  
vCenterの再起同時、名前解決ができないとサービスが上がらない

## 注意2
vCenterのnic追加は7.Xからマルチホーミングできるようになっている。  
nic0が管理用、nic1がvCenter HA用で予約されている。  
なので、nic2以降を追加する場合、vCenter HA用のnic1は切断状態で追加する必要がある。

## 
ある程度構築し終わったら、ローカルPCをFTPサーバとして機能させ、バックアップをとっておくと心穏やか

##
vmkの管理サービスはHAトラフィックの送受信をになっている。  
複数管理サービスvmkがあると、想定通りのHAをしない可能性がある。  
デフォルトで存在するvmkはサービスがなくても存在できる。(後付けのvmkは少なくとも1サービス必要なはず)
