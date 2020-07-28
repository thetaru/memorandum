# Ansible
# § INSTALL
## 前提条件
```
# cat /etc/redhat-release
```
```
CentOS Linux release 8.2.2004 (Core)
```
```
# uname -r
```
```
4.18.0-147.el8.x86_64
```
```
# python3 -V
```
```
Python 3.6.8
```
## 作業手順
### Pipのインストール
Ansibleはpipを使用してインストールします。
```
# yum -y install python3-pip eprl-release
```
### Ansible用のユーザ作成
```
# useradd ansible
```
```
# passwd ansible
```
```
新しいパスワード:
新しいパスワードを再入力してください:
passwd: すべての認証トークンが正しく更新できました。
```
### Ansibleのインストール
`ansible`ユーザのホームディレクトリにAnsibleをインストールするので、ユーザを`root`から`ansible`へ変更します。
```
# su - ansible
```
```
$ pip3 install ansible --user
```
```
...
Installing collected packages: MarkupSafe, jinja2, PyYAML, ansible
  Running setup.py install for PyYAML ... done
  Running setup.py install for ansible ... done
Successfully installed MarkupSafe-1.1.1 PyYAML-5.3.1 ansible-2.9.11 jinja2-2.11.2
```
```
# ansible --version
```
```
ansible 2.9.11
...
```
