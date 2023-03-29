---
title:  Ubuntu 安装 X11 和 Chrome 并远程（openai）
copyright: true
date: 2023-03-29 00:00:01
urlname: ubuntu-install-x11-chrome-remote-openai
tags: 
 - Docker
categories: linux
---
# 安装 chrome

<!--more-->
# 安装 Docker
[CentOS Stream](](../../2023-01-04/centos-stream-8-install-docker-and-link-portainer))
[Ubuntu 2204](](../../2023-03-29/ubuntu-2204-install-docker-and-link-portainer))

# 安装 X11

# 安装 VNC chrome
https://hub.docker.com/r/oldiy/chrome-novnc
https://hub.docker.com/r/oldiy/firefox-novnc
https://hub.docker.com/r/oldiy/firefox-enpass-novnc


```bash
docker run -d --restart=always --name remote-chrome -p 8083:8083 -p 5900:5900 oldiy/chrome-novnc:latest

```