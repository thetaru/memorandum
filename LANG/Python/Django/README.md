# Django
## ■ チートシート
### プロジェクトの作成
```
# django-admin startproject <project_name>
```

```
<project_name>
  ├ manage.py
  └ <project_name>
      ├ __init__.py
      ├ settings.py
      ├ urls.py
      ├ asgi.py
      └ wsgi.py
```

|ファイル名|役割|
|:---|:---|
|__init__.py|モジュールをインポートすると一番初めに読み込まれる|
|settings.py|プロジェクト全体の設定を行う|
|urls.py|ブラウザから受けたrequestをview.pyに渡す|
|asgi.py||
|wsgi.py||

