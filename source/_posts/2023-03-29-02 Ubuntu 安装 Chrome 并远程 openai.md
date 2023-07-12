---
title:  Ubuntu 安装 Docker Chrome 并远程（openai、newbing）
copyright: true
date: 2023-03-29 00:00:02
urlname: ubuntu-install-chrome-remote-openai-newbing
keywords: Docker CentOS Stream web VNC Chrome Edge Firefox Ubuntu 2204
tags: 
 - Docker
categories: linux
---
> 使用代理访问 openai 和 newbing 也是可以的，但是速度和稳定性都很差，刚好我有台机子在日本，不如直接在此上面安装 chrome 进行 web vnc 连接
# 安装 Docker
[CentOS Stream](](../../2023-01/centos-stream-8-install-docker-and-link-portainer))
[Ubuntu 2204](](../../2023-03/ubuntu-2204-install-docker-and-link-portainer))

# 安装 VNC chrome
> https://github.com/SeleniumHQ/docker-selenium
```bash
docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-chrome
docker run -d -p 4445:4444 -p 7901:7900 --shm-size="2g" selenium/standalone-edge
docker run -d -p 4446:4444 -p 7902:7900 --shm-size="2g" selenium/standalone-firefox
```