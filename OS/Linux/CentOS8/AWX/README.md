# AWX
:warning: 注意事項: CPU数とMEM数は十分与えておくこと。(さもないと、デプロイ時に失敗します)  
更新が頻繁に起こるので都度確認してください。
## ■ AWX Operatorの導入
```
# kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/devel/deploy/awx-operator.yaml
```
```
# kubectl get deployment
```
## ■ AWX のデプロイ
### Namespace
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: awx
```
### AWXリソース
```yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  admin_user: admin
  admin_password_secret: awx-admin-password
 
  ingress_type: ingress
  ingress_tls_secret: awx-secret-tls
  hostname: awx.example.com
 
  postgres_configuration_secret: awx-postgres-configuration
 
  postgres_storage_class: awx-postgres-volume
  postgres_storage_requirements:
    requests:
      storage: 2Gi
 
  projects_persistence: true
  projects_existing_claim: awx-projects-claim
```
### PV
```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: awx-postgres-volume
spec:
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  capacity:
    storage: 2Gi
  storageClassName: awx-postgres-volume
  hostPath:
    path: /data/postgres
 
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: awx-projects-volume
spec:
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  capacity:
    storage: 2Gi
  storageClassName: awx-projects-volume
  hostPath:
    path: /data/projects
```
### PVC
```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: awx-projects-claim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 2Gi
  storageClassName: awx-projects-volume
```
### Kustomize
```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: awx
 
generatorOptions:
  disableNameSuffixHash: true
 
secretGenerator:
  - name: awx-secret-tls
    type: kubernetes.io/tls
    files:
      - tls.crt
      - tls.key
 
  - name: awx-postgres-configuration
    type: Opaque
    literals:
      - host=awx-postgres
      - port=5432
      - database=awx
      - username=awx
      - password=Ansible123!
      - type=managed
 
  - name: awx-admin-password
    type: Opaque
    literals:
      - password=Ansible123!
 
resources:
  - namespace.yaml
  - pv.yaml
  - pvc.yaml
  - awx.yaml
```
### デプロイ
```
# kubectl apply -k .
```
