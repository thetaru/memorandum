# Django
## クラスベースビュー
|クラス名|用途|
|:---:|:---:|
|RedirectView|リダイレクトに特化した処理を行う|
|TemplateView|テンプレート表示に特化した処理を行う|
|ListView|モデルオブジェクトの一覧を表示する|
|CreateView|モデルオブジェクトを作成する|
|DetailView|モデルオブジェクトの詳細を表示する|
|UpdateView|モデルオブジェクトを更新する|
|DeleteView|モデルオブジェクトを削除する|
|FormView|フォーム処理をする|

## オーバーライドするクラス変数
|クラス名|対応するビュー|用途|
|:---:|:---:|:---:|
|template_name|RedirectView以外|テンプレート名を指定する|
|model|a|a|
|paginate_by|||
|queryset|||
|form_class|||
|success_url|||
|fields|||
