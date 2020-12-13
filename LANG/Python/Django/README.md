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
## settings.py
最初に設定するべき箇所を説明します。
### TEMPLATES
```
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        
        ### htmlファイルが入っているディレクトリを指定する
        'DIRS': [os.path.join(BASEDIR, 'templates')],
        
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```
### DATABASES
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```
### AUTH_PASSWORD_VALIDATORS
### LANGUAGE_CODE
## ■ urls.py
```
# vi <project_name>/urls.py
```
```
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
]
```
