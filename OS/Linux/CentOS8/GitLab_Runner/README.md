# GitLab Runnerの構築
### 概要
GitLab RunnerがGitLab上のコミットを検知してジョブを実行する  
### GitLab Runnnerの種類
GitLab Runnerには2つの動作モードが存在する。
|種類|説明|
|:---|:---|
|Shared RUnners|プロジェクトをまたいで共有できるRunner|
|Specific Runners|特定のプロジェクトのみのRunner|

### executorについて
GitLab Runnerにはジョブの実行方式`executor`を選択することができる。  
|executor|
|:---|
|Shell|
|Docker|
|Docker Machine and Docker Machine SSH (autoscaling)|
|Parallels|
|VirtualBox|
|SSH|
|Kubernetes|
