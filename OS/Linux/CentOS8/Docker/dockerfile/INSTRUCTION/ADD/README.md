# ファイル/ディレクトリの追加
ホスト上のファイル/ディレクトリやリモートファイルを、Dockerイメージ上にコピーします。
主にリモートファイルのコピーに使います。
## Syntax
```
ADD <ホストのファイルパス> <Docker-imageのファイルパス>
ADD ["<ホストのファイルパス>", "<Docker-imageのファイルパス>"]
```
## e.g.
### ADD命令の例
```
### ホスト上のhost.htmlファイルをdockerイメージ上の/docker_dir/に追加します
ADD host.html /docker_dir/
```
### WORKDIR命令とADD命令の例
```
### /docker_dirを起点にします
WORKDIR /docker_dir

### host.htmlを/docker_dir_web/に追加します
ADD host.html web/
```
### ADD命令でのリモートファイル追加
```
ADD https://github.com/thetaru/thetaru.github.io/blob/master/images/neko.png /docker_dir/web/
```
