# Django
## ■ プロジェクトの作成
プロジェクト名`project_name`は任意の値にしてください。
```
### プロジェクト作成
# django-admin startproject project_name
```
```
### htmlファイルの格納先を作成
# mkdir templates
```
```
project_name
  ├ manage.py
  ├ project_name
  │   ├ __init__.py
  │   ├ settings.py
  │   ├ urls.py
  │   ├ asgi.py
  │   └ wsgi.py
  └ templates
```
### データベースの設定
```
# vi project_name/settings.py
```
```py
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```
### 言語とタイムゾーンの設定
```
# vi project_name/settings.py
```
```py
# LANGUAGE_CODE = 'en-us'
LANGUAGE_CODE = 'ja'

# TIME_ZONE = 'UTC'
TIME_ZONE = 'Asia/Tokyo'
```
### データベースのマイグレーション
```
# python3 manage.py migrate
```
```
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying sessions.0001_initial... OK
```
### スーパーユーザの作成
```
# python3 manage.py createsuperuser
```
```
ユーザー名 (leave blank to use 'thetaru'): admin
メールアドレス: 
Password: 
Password (again): 
Superuser created successfully.
```
### 開発用サーバの起動
```
# python3 manage.py runserver
```
```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
December 13, 2020 - 21:40:27
Django version 3.1.4, using settings 'project_name.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```
## ■ アプリの作成
プロジェクトにアプリを作成します。  
アプリ名`app_name`は任意の値にしてください。
```
# python3 manage.py startapp app_name
```
```
project_name
  ├ manage.py
  ├ project_name
  │   ├ __init__.py
  │   ├ settings.py
  │   ├ urls.py
  │   ├ asgi.py
  │   └ wsgi.py
  ├ templates
  └ app_name
      ├ __init__.py
      ├ admin.py
      ├ app.py
      ├ migrations
      │  └ __init__.py
      ├ models.py
      ├ tests.py
      └ views.py
```
### モデルの作成
データベースに定義するデータモデルを、`app_name/models.py`に定義します。  
例として次のようなデータベースを考えます。

|書籍名|出版社|ページ数|
|:---|:---|:---|
|ハンズオンJavaScript|O'Reilly|740|
|Linuxシステムプログラミング|O'Reilly|396|

```
# vi app_name/models.py
```
```py
from django.db import models

class Book(models.Model):
    """書籍"""
    ### 
    name = models.CharField('書籍名', max_length=255)
    
    ### 
    publisher = models.CharField('出版社', max_length=255, blank=True)
    
    ### 
    page = models.IntegerField('ページ数', blank=True, default=0)

    def __str__(self):
        return self.name
```
### モデルを登録する
アプリを入れ、モデルを作成しました。  
作成したモデルをプロジェクトに登録します。  
  
`app_name/app.py`を開くと、`AppNameConfig`というクラスが定義されています。  
これを`project_name/settings.py`の`INSTALLED_APPS`に追加します。
```
# vi project_name/settings.py
```
```py
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app_name.apps.AppNameConfig',
]
```
以下のコマンドで、models.py の変更を拾って、マイグレートファイルを作成します。
```
# python3 manage.py makemigrations app_name
```
```
Migrations for 'app_name':
  app_name/migrations/0001_initial.py
    - Create model Book
```
このマイグレートファイルが、どのような SQL になるか、以下のコマンドで確認できます。
```
# python3 manage.py sqlmigrate app_name 0001
```
```
BEGIN;
--
-- Create model Book
--
CREATE TABLE "app_name_book" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL, "publisher" varchar(255) NOT NULL, "page" integer NOT NULL);
COMMIT;
```
まだデータベースに反映していないマイグレートファイルを、以下のコマンドでデータベースに反映します。
```
# python3 manage.py migrate app_name
```
```
Operations to perform:
  Apply all migrations: app_name
Running migrations:
  Applying app_name.0001_initial... OK
```
