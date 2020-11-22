# Elasticsearch + Kibana + Filebeat
ElasticsearchとKibanaとFilebeatでsyslog分析サーバ構築ログ  
:warning:検索方法等もう少し煮詰める必要あり
|software|version|
|:---|:---|
|elasticsearch|7.9.2|
|kibana|7.9.2|
|Filebete|7.9.2|

<details>
<summary>Elasticsearch</summary>

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
ファイルディスクリプタ数を上げます。
```
### drop-inでもいいです
# vi /usr/lib/systemd/system/elasticsearch.service
```
```
### ファイルディスクリプタの上限変更
[Service]
+  LimitNOFILE=65536
+  LimitNPROC=65536
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
</details>

<details>
<summary>Kibana</summary>

## ■ インストール
```
# rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```
```
# cat <<EOF > /etc/yum.repos.d/kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```
```
### kibanaのインストール
# yum install kibana
```
```
# systemctl daemon-reload
# systemctl start kibana.service
# systemctl enable kibana.service
```
## ■ 設定
```
# vi /etc/kibana/kibana.yml
```
```
### 接続元IPアドレス制限
-  #server.host: "localhost"
+  server.host: "0.0.0.0"

### 日本語化
-  #i18n.defaultLocale: "en"
+  i18n.locale: "ja-JP"
```
</details>

<details>
<summary>Filebeat</summary>

## ■ インストール
```
# curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.9.2-x86_64.rpm
# rpm -vi filebeat-7.9.2-x86_64.rpm
```
## ■ 設定
```
# vi /etc/filebeat/filebeat.yml
```
```
# =================================== Kibana ===================================
-  #host: "localhost:5601"
+  host: "localhost:5601"
```
```
# cp -i /etc/filebeat/modules.d/system.yml.disabled /etc/filebeat/modules.d/system.yml
# vi /etc/filebeat/modules.d/system.yml
```
```
- module: system
  syslog:
    enabled: true
-     #var.paths:
+     var.paths: ["/var/log/messages*"]
```
```
# filebeat modules enable system
```
```
# filebeat setup
# systemctl start filebeat
# systemctl enable filebeat
```
</details>

https://acro-engineer.hatenablog.com/entry/2018/12/13/120000  
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-log.html  
