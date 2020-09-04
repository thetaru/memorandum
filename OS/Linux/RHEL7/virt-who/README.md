# virt-who
RHELのサブスクリプションを管理します。ここではvCenter管理下での設定をします。
## virt-whoのインストール
vCenterに管理されているEsxi上に存在するRHEL仮想マシン1台に対してのみインストールします。  
設定に関しても同様です。
```
### ローカルリポジトリなどを使ってインストール
# yum -y install virt-who
```
## virt-whoの設定
```
### 設定ファイルの新規作成(ホスト名.confでいいと思います)
# vi /etc/virt-who.d/vcetner.conf
```
```
[vcenter]                                 # 任意ですが、[ホスト名] でいいと思います
type=esx                                  
server=<vCenterのIPアドレス>
username=<vCetnerのユーザー>
password=<ユーザーのパスワード>
owner=xxxxxxxx                            # subscription-manager identity より 組織 ID を記載
env=Library
hypervisor_id=hostname
```
## virt-whoの起動
virt-whoが起動するとRed Hat Customer Portal上でEsxiが認識されるようになります。
```
# systemctl start virt-who.service
# systemctl enable virt-who.service
```
## RHNからEsxiのサブスクリプション登録
Red Hat Customer Portalから「サブスクリプション」-「システム」より認識されたEsxiに対して「サブスクリプションのアタッチ」でサブスクリプション登録します。
## 仮想マシンのサブスクリプション登録
仮想マシンのサブスクリプション登録に関しては[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/RHEL7/subscription)を参考にしてください。
