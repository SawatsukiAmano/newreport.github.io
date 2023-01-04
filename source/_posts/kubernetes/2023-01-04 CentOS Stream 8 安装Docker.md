---
title: CentOS Stream 8 安装Docker并连接Portainer
copyright: true
date: 2023-01-04 00:00:01
urlname: centos-stream-8-install-docker-and-link-portainer
tags: 
 - Docker
categories: docker/podman
---

1. 卸载老版本
```bash
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
```

2. 安装docker 基础包
```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
```
<!-- more -->  
3. 设置仓库
```bash
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

4. 安装Docker Engine 
```bash
yum install docker-ce docker-ce-cli containerd.io
```

5. 编辑docker.service
>找到 ExecStart字段修改如下，添加2375远程端口（粗体部分），
```bash
vim /usr/lib/systemd/system/docker.service
```
>ExecStart=/usr/bin/dockerd **-H tcp://0.0.0.0:2375** -H unix://var/run/docker.sock

6. 重启服务
```bash
systemctl daemon-reload
systemctl restart docker
```