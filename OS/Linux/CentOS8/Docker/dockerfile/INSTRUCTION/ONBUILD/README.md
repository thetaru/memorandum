# ビルド完了時に実行される命令
## Syntax
ONBUILD [exec command]
## e.g.
ONBUILD命令は、自身のDockerfileから生成したイメージをベースイメージとした別のDockerfileをビルドするときに実行したいコマンドを記述する。
