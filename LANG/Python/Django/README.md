# Django
## ■ プロジェクトの作成
```
### プロジェクト作成
# django-admin startproject <project_name>
```
```
### htmlファイルの格納先を作成
# mkdir templates
```
```
<project_name>
  ├ manage.py
  ├ <project_name>
  │   ├ __init__.py
  │   ├ settings.py
  │   ├ urls.py
  │   ├ asgi.py
  │   └ wsgi.py
  └ templates
```
### データベースの設定
```
# vi <project_name>/settings.py
```
```
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
# vi <project_name>/settings.py
```
```
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
```
# python3 manage.py startapp <app_name>
```
```
<project_name>
  ├ manage.py
  ├ <project_name>
  │   ├ __init__.py
  │   ├ settings.py
  │   ├ urls.py
  │   ├ asgi.py
  │   └ wsgi.py
  ├ templates
  └ <app_name>
      ├ __init__.py
      ├ admin.py
      ├ app.py
      ├ migrations
      │  └ __init__.py
      ├ models.py
      ├ tests.py
      └ views.py
```
