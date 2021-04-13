# Gitlab Runnerの構築
## ■ Install
[こちら](https://docs.gitlab.com/runner/install/linux-repository.html)を参考に構築していきます。
### 1. 公式のレポジトリをインストール
```
# curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
```
### 2. 最新のGitLab Runnerをインストール
```
# export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E yum install gitlab-runner
```
### 3. Runnerの登録
```
# gitlab-runner register
```
```
Enter the GitLab instance URL (for example, https://gitlab.com/):
http://192.168.0.100/                                                                              
Enter the registration token:
<管理者エリア - 概要 - Runnerより画面右側から登録用トークンを取得>
Enter a description for the runner:
[test-srv]: 
Enter tags for the runner (comma-separated):

Registering runner... succeeded                     runner=ze_Antye
Enter an executor: custom, docker-ssh, ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, shell, virtualbox:
kubernetes
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
```
