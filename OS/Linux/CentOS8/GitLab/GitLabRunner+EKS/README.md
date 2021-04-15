# GitLab + Kustomize + CodePipeline + CodeBuild 連携
```
             push                     Build                  apply
+--------+          +--------------+          +-----------+          +-----+
| GitLab | -------> | CodePipeline | -------> | CodeBuild | -------> | EKS |
+--------+          +--------------+          +-----------+          +-----+
```
## 前提条件
EKSクラスタは既に構築してあるとします。
