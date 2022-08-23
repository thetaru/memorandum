# Rook-Ceph
## ■ 事前知識
### ストレージインターフェース
Cephでは主に3つある。
- Ceph File System
- Ceph Block Device
- Ceph Object Gateway

Ceph File System(CephFS)のボリュームは複数ノードのPodでマウントできる。(RWX)  
一方、Ceph Block Device(RBD)のボリュームは単一ノードのPodでのみマウントできる。(RWO)
