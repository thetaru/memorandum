# Elasticsearch
## ■ インストール
```
# cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF
```
```
### Elasticsearchのインストール
# yum install --enablerepo=elasticsearch elasticsearch
```
```
# systemctl daemon-reload
# systemctl start elasticsearch.service
# systemctl enable elasticsearch.service
```
## ■ 設定
```
# vi /usr/lib/systemd/system/elasticsearch.service
```
```

```
Elasticsearchの割り当てメモリを変更(ヒープサイズ)します。  
`Xms`と`Xmx`の値は等しくすること。デフォルトでは以下のように1GBが指定されています。  
全メモリの50%を越えないように設定するのが推奨されているようです。
```
# vi /etc/elasticsearch/jvm.options
```
```
-Xms1g
-Xmx1g
```
```
# vi /etc/elasticsearch/elasticsearch.yml
```
```
# ---------------------------------- Network -----------------------------------
### 接続元IPアドレス制限
-  network.host: 192.168.0.1
+  network.host: 0.0.0.0

# --------------------------------- Discovery ----------------------------------
### クラスタを組まないようにする
+  discovery.type: single-node

### 末尾に追記
+  # ---------------------------------- For kibana -----------------------------------
+  http.cors.enabled: true
```
