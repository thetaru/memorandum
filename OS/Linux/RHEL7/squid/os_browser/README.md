# OS・ブラウザによる制限
```
# define denied OS
acl DenyOS browser -i windows.95
acl DenyOS browser -i windows.98

# define denied Browser
acl DenyBrowser -i MSIE.4
acl DenyBrowser -i MSIE.5

# Deney OS/Browser
http_access deny DenyOS
http_access deny DenyBrowser

# Show Error message on Browser(※/etc/share/squid/errors/English に ERR_SECURITY_DENY ファイルを置く)
deny_info ERR_SECURITY_DENY DenyOS
deny_info ERR_SECURITY_DENY DenyBrowser
```
