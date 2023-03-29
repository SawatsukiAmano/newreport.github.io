---
title: CentOS Stream 8 安装 Docker 并连接 Portainer
copyright: true
date: 2023-01-04 00:00:01
urlname: centos-stream-8-install-docker-and-link-portainer
tags: 
 - Docker
 - Portainer
categories: kubernetes/docker/podman
---

1. 卸载老版本
```bash
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
```

2. 安装 docker 基础包
```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
```
<!-- more -->  
3. 设置仓库
```bash
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

4. 安装 Docker Engine 
```bash
yum install docker-ce docker-ce-cli containerd.io
```

5. 编辑 docker.service
> 找到 ExecStart 字段修改如下，添加 2375 远程端口（粗体部分）
```bash
vim /usr/lib/systemd/system/docker.service
```
> ExecStart=/usr/bin/dockerd **-H tcp://0.0.0.0:2375** -H unix://var/run/docker.sock
6. 重启服务
```bash
systemctl daemon-reload
systemctl restart docker
```