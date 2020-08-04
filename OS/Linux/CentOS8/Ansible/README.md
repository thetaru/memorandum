# Ansible
# § INSTALL
```
# yum -y install epel-release
# yum -y install ansible
```
```
### version確認
# ansible --version
```
```
ansible 2.9.11
```
## やりたいこと
playbook作り  
テンプレートとなるplaybookをまず作る。  
それをもとにして各種ミドルが乗ったplaybookを作って展開する。  
AWSも自動構築できるようにしたい
