# Django
## §1. ビュー
### クラスベースビュー
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

### オーバーライドするクラス変数
|クラス変数名|対応するビュー|用途|
|:---:|:---:|:---:|
|template_name|RedirectView以外|テンプレート名を指定する|
|model|ListView<br>CreateView<br>DetailView<br>UpdateView<br>DeleteView|モデルを指定する<br>※querysetを設定していない場合は必須|
|paginate_by|ListView|1ページに表示する件数を指定する|
|queryset|ListView<br>CreateView<br>DetailView<br>UpdateView<br>DeleteView|テンプレートにクエリーセットを渡す<br>※modelを設定しない場合は必須|
|form_class|CreateView<br>UpdateView<br>FormView|フォームクラス名を指定する|
|success_url|CreateView<br>UpdateView<br>DeleteView<br>FormView|処理成功時にリダイレクトさせるURLを指定する|
|fields|CreateView<br>UpdateView|ビューで使うフォームのフィールドを指定する|

### オーバーライドするメソッド
|メソッド名|対応するビュー|用途|
|:---:|:---:|:---:|
|get_context_data|RedirectView以外|テンプレートに辞書データを渡す|
|get_queryset|ListView<br>CreateView<br>DetailView<br>UpdateView<br>DeleteView|テンプレートにクエリーセットを渡す|
|form_valid|CreateView<br>UpdateView<br>FormView|フォームバリデーションに問題がない場合の処理を記述する|
|form_invalid|CreateView<br>UpdateView<br>FormView|フォームバリデーションに問題がある場合の処理を記述する|
|get_success_url|CreateView<br>UpdateView<br>DeleteView<br>FormView|処理成功時にリダイレクトさせるURLを指定する|
|delete|DeleteView|削除処理時に何を処理するかを追加する|
|get|すべて|他のメソッドには当てはまらないGET通信時の処理を記述する|
|post|RedirectView<br>CreateView<br>UpdateView<br>DeleteView<br>FormView|他のメソッドには当てはまらないPOST通信時の処理を記述する|

## §2. フォーム
### §2.1 フォームの定義方法
form.pyに```django.forms.Form```クラスまたは```django.forms.ModelForm```クラスを継承する。
### フィールドクラス
|フィールドクラス|デフォルトのウィジェット|デフォルトHTMLタグ|
|:---:|:---:|:---:|
|CharField|TextInput|\<input type="text"\>|
|IntegerField|NumberInput|\<input type="number"\>|
|ChoiceField|Select|\<select\>|
|DateField|DateInput|\<input type="text"\>|
|DateTimeField|DateTimeInput|\<input type="text"\>|
|EmailField|EmailInput|\<input type="email"\>|
|FileField|ClearableFileInput|\<input type="file"\>|
|ImageFiled|ClearableFileInput|\<input type="file"\>|

### フィールドオプション
|フィールドオプション|用途|補足|
|:---:|:---:|:---:|
|required|必須フィールドにするかどうか|True または Falseを設定する(デフォルトはTrue)|
|label|フォーム画面のラベルを設定する|-|
|widget|ウィジェットを設定|-|
|validators|バリデータを設定|-|

## §3. テンプレート
### Djangoテンプレート言語
|記法|用途|
|{{<変数名>}}<br>{{<変数名>.<キー名>}}<br>{{<変数名>|<フィルタ>}}|変数を表示する。フィルタは変数の表示を制御する。|
|{%<タグ名>%}|条件分岐などの処理を行う。|
|{#<コメント>#}|コメントを記述する。|

