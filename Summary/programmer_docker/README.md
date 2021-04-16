# Docker
## ■ INSTALL
[公式](https://docs.docker.com/engine/install/centos/)を参照してください。  
バージョンや依存関係でインストールできない場合は[ここ](https://download.docker.com/linux/)からパッケージを探します。
```
# yum -y install https://download.docker.com/linux/<path_to_rpm>
```
podmanでエミュレートしたdockerを使用する場合は以下のコマンドを実行します。
```
# yum -y install podman-docker
```
## ■ COMMANDS
### container
- [x] [**docker container attach**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20attach)
- [x] [docker container commit](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20commit)
- [x] [docker container cp](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20cp)
- [ ] [docker container diff](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20diff)
- [x] [**docker container exec**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20exec)
- [x] [docker container export](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20export)
- [x] [docker container import](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20import)
- [x] [**docker container ls**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20ls)
- [x] [docker container pause／unpause](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20pause%EF%BC%8Funpause)
- [x] [**docker container port**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20port)
- [x] [docker container rename](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20rename)
- [x] [docker container restart](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20restart)
- [x] [**docker container rm**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20rm)
- [x] [**docker container run**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20run)
- [x] [**docker container start**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20start)
- [x] [**docker container stats**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20stats)
- [x] [docker container stop](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20stop)
- [x] [docker container top](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/container/docker%20container%20top)
### image
- [x] [docker image inspect](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20inspect)
- [x] [docker image load](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20load)
- [x] [docker image login／logoff](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20login%EF%BC%8Flogoff)
- [x] [**docker image ls**](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20ls)
- [x] [docker image pull](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20pull)
- [x] [docker image push](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20push)
- [x] [docker image rm](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20rm)
- [x] [docker image save](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20save)
- [x] [docker image search](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20search)
- [x] [docker image tag](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/image/docker%20image%20tag)
### network
- [x] [docker network connect／disconnect](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/network/docker%20network%20connect%EF%BC%8Fdisconnect)
- [x] [docker network create](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/network/docker%20network%20create)
- [x] [docker network inspect](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/network/docker%20network%20inspect)
- [x] [docker network ls](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/network/docker%20network%20ls)
- [x] [docker network rm](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/network/docker%20network%20rm)
### system
- [x] [docker system df](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/system/docker%20system%20df)
- [x] [docker system info](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/system/docker%20system%20info)
- [ ] [docker system prune](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/system/docker%20system%20prune)
- [x] [docker system version](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/system/docker%20system%20version)
### others
- [ ] [docker login]()
## ■ Dockerfile
### Instruction
- [x] [ADD](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ADD)
- [x] [ARG](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ARG)
- [x] [CMD](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/CMD)
- [ ] [COPY](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/COPY)
- [x] [ENTRYPOINT](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ENTRYPOINT)
- [x] [ENV](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ENV)
- [x] [EXPOSE](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/EXPOSE)
- [ ] [HEALTHCHECK](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/HEALTHCHECK)
- [ ] [LABEL](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/LABEL)
- [x] [ONBUILD](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/ONBUILD)
- [x] [RUN](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/RUN)
- [x] [SHELL](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/SHELL)
- [ ] [STOPSIGNAL](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/STOPSIGNAL)
- [x] [USER](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/USER)
- [ ] [VOLUME](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/VOLUME)
- [x] [WORKDIR](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Docker/dockerfile/INSTRUCTION/WORKDIR)
