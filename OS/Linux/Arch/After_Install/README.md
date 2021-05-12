# インストール後にやること
以下、ディストリはmanjaroを想定しています。  
シェルにまとめてしまいたいですね、やることリストみたいな感じのメモになります。  
ふだんXはそんなに使う機会が多くないので忘れる前にちょくちょく更新予定です。
デスクトップ環境はGNOMEなのでxfceやKDE使っている場合はあまり参考にならないかもしれないです。
## リポジトリのミラーサーバーリストを変更
```
$ sudo pacman-mirrors --fasttrack
```
## リポジトリの同期とソフトウェアの更新
```
$ sudo pacman -Syyu
```
## yay をインストール
```
$ sudo pacman -Syu yay
```
## vscode をインストール
```
$ sudo pacman -Syu code
```
## Fcitx-Mozc をインストール
```
$ sudo pacman -S fcitx-im fcitx-mozc
```
## Remmina をインストール
```
$ sudo pacman -S remmina freerdp
```
## 隠しファイルの表示
ファイルマネージャから`隠しファイルを表示`で設定
## ログインシェルの変更
ログインシェルを`/bin/bash`に変更します。(個人的に使い慣れているってだけの理由です。)
```
$ sudo chsh <USER> -s /bin/bash
```
## 日本語入力系
ファイル末尾に追記します。
```
$ sudo vi ~/.bashrc
```
```
export GTK_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
```
```
$ sudo vi ~/.xprofile
```
```
export GTK_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
```
## ホームディレクトリを英語化
```
$ sudo pacman -S xdg-user-dirs-gtk
```
```
$ LANG=C xdg-user-dirs-gtk-update
```
再起動するとホームディレクトリが英語になります。
## [Option] SSDのTrimコマンドを有効にする
```
$ sudo systemctl start fstrim.timer
$ sudo systemctl enable fstrim.timer
```
## キャッシュを RAM ディスク上に
sizeは環境に応じて設定しましょう。
```
$ sudo vi /etc/fstab
```
```
tmpfs /home/<USER>/.cache tmpfs noatime,nodev,nosuid,size=2G 0 0
```
```
$ mount -a
```
## CapsLockをCtrlにする
```
$ sudo gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
```
## キーバインドをEmacs風にする
たびたび設定が剥がれるので`/etc/profile.d/key-bind.sh`を作成することにした。
```
$ sudo vim /etc/profile.d/key-bind.sh
```
```
#!/bin/bash

### CapsLock -> Ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
gsettings set org.gnome.desktop.interface gtk-key-theme Emacs
```
## ショートカットの作成
### ホームフォルダー
`ランチャー`-`ホームフォルダー`を`Super+E`に変更
### スクリーンショット
`スクリーンショット`-`ウィンドウのスクリーンショットをPicturesフォルダに保存する`を`Shft+Ctrl+F9`に変更
## 電源
環境に合わせて設定する。
## バックアップ
定期バックアップできるようにする。
