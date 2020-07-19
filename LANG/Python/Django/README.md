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
|model|ListView<br>CreateView<br>DetailView<br>UpdateView<br>DeleteView|モデルを指定する<br>※querysetを設定していない場合は必須|
|paginate_by|ListView|1ページに表示する件数を指定する|
|queryset|ListView<br>CreateView<br>DetailView<br>UpdateView<br>DeleteView|テンプレートにクエリーセットを渡す<br>※modelを設定しない場合は必須|
|form_class|CreateView<br>UpdateView<br>FormView|フォームクラス名を指定する|
|success_url|CreateView<br>UpdateView<br>DeleteView<br>FormView|処理成功時にリダイレクトさせるURLを指定する|
|fields|CreateView<br>UpdateView|ビューで使うフォームのフィールドを指定する|
