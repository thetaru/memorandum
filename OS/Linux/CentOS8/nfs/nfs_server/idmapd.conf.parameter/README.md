# ■ General
## Domain (★)
|デフォルト値|-|
|:---|:---|

ドメイン名を指定します。  
NFSv4ではユーザを`user@domain`の形式で扱うため必須となります。

# ■ Mapping
## Nobody-User (★)
|デフォルト値|nobody|
|:---|:---|

`/etc/exports`ファイルのオプション`root_squash`, `all_squash`を指定した場合に割り当てられるデフォルトのユーザを指定します。 

## Nobody-Group (★)
|デフォルト値|nobody|
|:---|:---|

`/etc/exports`ファイルのオプション`root_squash`, `all_squash`を指定した場合に割り当てられるデフォルトのグループを指定します。 

# ■ Translation
## Method
|デフォルト値|nsswitch|
|:---|:---|

UNIX側ユーザID/グループIDの取得方法を指定します。
