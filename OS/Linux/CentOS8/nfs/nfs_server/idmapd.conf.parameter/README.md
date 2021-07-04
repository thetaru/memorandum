# ■ General
## Domain (★)
|デフォルト値|-|
|:---|:---|

ドメイン名を指定します。  
NFSv4ではユーザを`user@domain`の形式で扱うため必須となります。

## No-Strip
## Reformat-Group
## Local-Realms

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
## Method (★)
|デフォルト値|nsswitch|
|:---|:---|

## GSS-Methods
