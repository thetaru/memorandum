# AWX
## 前提条件

|項目|設定値|
|:---|:---|
|OS|CentOS8|
|CPU|4|
|MEM|8GB|
|Storage|700GB|
|Software|AWX17.0|

## § INSTALL
### ■ Python
もし入っていなかったら`python3`をインストールします。
```
# yum install python3
```
#### venv(Python仮想環境管理)
環境を汚さないためにvenvを使って仮想環境を作成します。  
以下では`awx_venv`という名前で作成します。
```
### Python仮想環境管理用ディレクトリを作成
# mkdir -p /opt/python/venv
# cd /opt/python/venv

### 仮想環境作成
# python3 -m venv awx_venv

### 仮想環境をアクティベート(以後抜けない限り 仮想環境のPythonが実行される)
# source awx_venv/bin/activate
```
以下、仮想環境で実行している場合は`(awx_venv)`をプロンプトの頭に付けます。

### ■ Ansible
Ansibleを`pip`コマンドでインストールします。
```
(awx_venv) # pip install --upgrade pip
(awx_venv) # pip install ansible
```
### ■ Docker操作用Pythonモジュール
```
(awx_venv) # pip install docker docker-compose selinux
```
### ■ Docker
AWXはコンテナ上で動作するため`Docker`をインストールします。  
もし`podman`が先に動いていた場合はアンインストールしてからにしましょう。  
※ podman complete uninstallとかでググると出てくると思います。
```
(awx_venv) # yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
(awx_venv) # yum install docker-ce docker-ce-cli containerd.io
```
`Docker`をインストール後、サービスの起動と自動起動を有効にします。
```
(awx_venv) # systemctl start docker.service
(awx_venv) # systemctl enable docker.service
(awx_venv) # systemctl status docker.service
```
### ■ Kubernetes
#### kubectlのインストール
```
(awx_venv) # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# yum install -y kubectl
```
#### Helmのインストール
```
(awx_venv) # curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```
### ■ Git
AWXのリポジトリのダウンロードをするために`Git`をインストールします。
```
(awx-venv) # yum install git
```
### ■ AWX
GitHubのAWXリポジトリをクローンします。
```
(awx-venv) # cd /tmp
(awx-venv) # git clone https://github.com/ansible/awx.git
```
#### パラメータ設定
`/tmp/awx/installer`はPlaybookになっており上でインストールしたAnsibleを使ってコンテナ上に展開していきます。  
その前に`/tmp/awx/installer/inventory`を編集してパラメータを指定していきます。
```
(awx-venv) # cd /tmp/awx/installer/
(awx-venv) # vi inventory
```
```
###  ターゲットノードで使用するPythonインタプリタのパスを変更する
-  localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python3"
+  localhost ansible_connection=local ansible_python_interpreter="/opt/python/venv/awx_venv/bin/python"

### PostgreSQLコンテナのDB領域指定
-  postgres_data_dir="~/.awx/pgdocker"
+  postgres_data_dir="/var/lib/awx/pgdocker"

### Docker Compoesのファイルディレクトリ
-  docker_compose_dir="~/.awx/awxcompose"
+  docker_compose_dir="/var/lib/awx/awxcompose"

### adminパスワードの変更
-  #  admin_password=password
+  admin_password=password
```
パラメータを設定したらPlaybookを実行してAWXをインストールします。
```
(awx-venv) # ansible-playbook -i inventory install.yml
```
