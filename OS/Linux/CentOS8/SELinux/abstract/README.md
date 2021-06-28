# SELinux機能の概要
## ■ アクセス制限モデル
### ● Type Enforcement (TE)
ファイルのパーミッションとは別のアクセス制御です。  
プロセスがアクセスできるリソース(ファイル、ディレクトリ、ソケットなどの総称)を制限できます。
### ● Role-based Access Control (RBAC)
### ● Multi-level Security/Multi-category Security (MLS/MCS)
## ■ SELinuxコンテキスト
任意のプロセスとリソースはSELinuxコンテキストがラベル付けされています。  
「誰が」「何に対して」「何ができる」かを記述します。
#### Syntax - SELinux contexts
```
<SELinux User>:<RBAC Role>:<TE Type>:<MLS/MCS Security level>
```
- ユーザ属性
> サブジェクトやオブジェクトに付けるSELinuxのユーザID
- ロール属性
>
- タイプ属性
>
- 機密ラベル
>

#### 例 - SELinux contexts
```
system_u:object_r:admin_home_t:s0
```
## ■ TE
### ドメインとタイプ
ドメインとタイプを使い、許可する動作をルールとして記述します。  
※ ドメインとはプロセスのタイプを指し、リソースのタイプと区別します。
### アクセス制御

## ■ RBAC
## ■ MLS/MCS
## ■ ref
https://www.ffri.jp/assets/files/monthly_research/MR201406_A%20Re-introduction%20to%20SELinux_JPN.pdf  
https://www.google.com/url?sa=t&source=web&rct=j&url=https://www.nic.ad.jp/ja/materials/iw/2017/proceedings/d1/d1-3-moriwaka-1.pdf&ved=2ahUKEwjd3q7mlrLxAhV3wosBHcYDDS8QFjAAegQIAxAC&usg=AOvVaw0TUVpDyiwyrAjDCCapIycc  
https://www.google.com/url?sa=t&source=web&rct=j&url=https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/pdf/using_selinux/Red_Hat_Enterprise_Linux-8-Using_SELinux-ja-JP.pdf&ved=2ahUKEwjC-4D9lrLxAhUUJaYKHZclBhUQFjABegQIBRAC&usg=AOvVaw1eYgLHrS5yWnIv_lVpzXOF&cshid=1624603320845
