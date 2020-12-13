# Django
## ■ プロジェクトの作成
プロジェクト名`project_name`は任意の値にしてください。
```
### プロジェクト作成
# django-admin startproject project_name
```
```
### htmlファイルの格納先を作成
# cd project_name && mkdir templates
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
アプリ名`application_name`は任意の値にしてください。
```
# python3 manage.py startapp application_name
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
  └ application_name
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
データベースに定義するデータモデルを、`application_name/models.py`に定義します。  
例として次のようなデータベースを考えます。

|書籍名|出版社|ページ数|
|:---|:---|:---|
|ハンズオンJavaScript|O'Reilly|740|
|Linuxシステムプログラミング|O'Reilly|396|

```
# vi application_name/models.py
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
  
`application_name/app.py`を開くと、`ApplicationNameConfig`というクラスが定義されています。  
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
    'application_name.apps.ApplicationNameConfig',
]
```
以下のコマンドで、models.py の変更を拾って、マイグレートファイルを作成します。
```
# python3 manage.py makemigrations application_name
```
```
Migrations for 'application_name':
  application_name/migrations/0001_initial.py
    - Create model Book
```
このマイグレートファイルが、どのような SQL になるか、以下のコマンドで確認できます。
```
# python3 manage.py sqlmigrate application_name 0001
```
```
BEGIN;
--
-- Create model Book
--
CREATE TABLE "application_name_book" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL, "publisher" varchar(255) NOT NULL, "page" integer NOT NULL);
COMMIT;
```
まだデータベースに反映していないマイグレートファイルを、以下のコマンドでデータベースに反映します。
```
# python3 manage.py migrate application_name
```
```
Operations to perform:
  Apply all migrations: application_name
Running migrations:
  Applying application_name.0001_initial... OK
```
### 管理サイトの有効化
管理サイトを表示します。
```
### 開発サーバを起動してからグーグルで開く
# python3 manage.py runserver && google-chrome http://127.0.0.1:8000/admin/
```
ログイン画面がでたら、上記で作成したスーパーユーザ`admin/thetaru`でログインします。
### アプリのモデルをadmin上で編集可能にする
```
# vi application_name/admin.py
```
```
from django.contrib import admin
from application_name.models import Book

admin.site.register(Book)
```
もう一度、`http://127.0.0.1:8000/admin/`を見てみましょう。  
`APPLICATION_NAME`が追加され、`Book`の要素があります。  
データの追加、修正、削除ができることを確認してください。
### 管理サイトの一覧ページをカスタマイズする
管理サイトの一覧を見たとき、`models.py`の
```
def __str__(self):
```
で設定したものが、レコード名として見えています。  
レコードの項目全体が見えるように、`application_name/admin.py`を修正しましょう。
```
# vi application_name/admin.py
```
```
from django.contrib import admin
from application_name.models import Book

class BookAdmin(admin.ModelAdmin):
    ### 一覧に出したい項目
    list_display = ('id', 'name', 'publisher', 'page',)
    ### 修正リンクでクリックできる項目
    list_display_links = ('id', 'name',)
    
admin.site.register(Book, BookAdmin)
```
モデルに追加したテーブルの一覧、登録、修正、削除ができることが確認できました。
## ■ CRUD
### ビューを作る
一覧、登録、修正、削除に対応する関数を`application_name/views.py`に作ります。  
登録、修正は編集としてひとまとめにしています。(book_idの指定がなければ登録、あれば修正とします)
```
# vi application_name/views.py
```
```
from django.shortcuts import render
from django.http import HttpResponse

def book_list(request):
    """書籍の一覧"""
    return HttpResponse('書籍の一覧')

def book_edit(request, book_id=None):
    """書籍の編集"""
    return HttpResponse('書籍の編集')

def book_del(request, book_id):
    """書籍の削除"""
    return HttpResponse('書籍の削除')
```
### URL スキームの設計
`application_name/urls.py`を新規作成して、URLとViewの関数の紐付けを行います。
```
# vi application_name/urls.py
```
```
from django.urls import path
from application_name import views

app_name = 'application_name'
urlpatters = [
    # Book
    ### 一覧
    path('book/', views.book_list, name='book_list'),
    ### 登録
    path('book/add/', views.book_edit, name='book_add'),
    ### 修正
    path('book/mod/<int:book_id>/', views.book_edit, name='book_mod'),
    ### 削除
    path('book/del/<int:book_id>/', views.book_del, name='book_del'),
]
```
次に、`application_name/urls.py`をプロジェクト全体の`project_name/urls.py`の中でインクルードします。
```
# vi project_name/urls.py
```
```
from django.contrib import admin
from django.urls import path, include # includeを追加

urlpatterns = [
    path('admin/', admin.site.urls),
    path('application_name', include('application_name.urls')), # ここでinclude
]
```
