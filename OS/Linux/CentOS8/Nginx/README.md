# Nginx
## §1. INSTALL
### 起動
```
# systemctl start nginx
# systemctl enable nginx
```
## §2. Config
```/etc/nginx/nginx.conf```を編集します。  
ここでは必要な項目のみに絞って紹介します。  
https://qiita.com/syou007/items/3e2d410bbe65a364b603  
https://qiita.com/ryuichi1208/items/50594810be613d838948  
https://qiita.com/morrr/items/7c97f0d2e46f7a8ec967  
```worker_processes```
```worker_rlimit_nofile```
```eventsブロック```
```worker_connectinos```
```multi_accept```
```httpブロック```
```server_tokens```
```include /etc/nginx/mime.types```x  
```default_type```x  
```charset```
```sendfile```
```tcp_nopush```
```tcp_nodelay```
```keepalive_timeout```
```keepalive_requests```
```set_real_ip_from``` ```real_ip_header```
```limit_conn_zone```
```limit_conn```

proxy  
```
proxy_buffering on;
proxy_buffer_size     8k;
proxy_buffers         100 8k;
proxy_cache_path 
```

```open_file_cache```
```server_names_hash_bucket_size```

```upstream```
```proxy_set_header```aeue  
```serverブロック```
```listen servername```
```root```
```rewrite```

```locationブロック```
```stub_status allow deny```
```expires```

