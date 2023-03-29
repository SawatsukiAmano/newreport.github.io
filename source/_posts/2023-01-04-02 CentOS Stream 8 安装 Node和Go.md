---
title: CentOS Stream 8 安装 Node 和 Go
copyright: true
date: 2023-01-04 00:00:02
urlname: centos-stream-8-install-node-and-go
tags: 
 - Node
 - Golang
categories: linux
---
# 安装 node 和 npm
```bash
yum install -y nodejs npm  # yum 安装node和npm
node -v # 查看 node 版本
npm install -g n # 安装 n 工具
n stable # 更新 node 到最新稳定版本
# n latest # 更新 node 到最新版
# bash # 刷新bash
node -v # 查看 node 已经更新至新版
npm install -g yarn # 安装 yarn
yarn -v # 查看 yarn 版本
yarn add vite # 安装 vite
```
<!-- more -->  

# 安装 golang 和 beego/bee
> golang 官网 https://golang.google.cn/learn/

> 安装教程 https://golang.google.cn/doc/install

```bash
wget https://golang.google.cn/dl/go1.19.4.linux-amd64.tar.gz # 下载 golang
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz # 解压到对应位置
echo "PATH=\$PATH:/usr/local/go/bin" >> /etc/profile # 写入全局变量
echo "PATH=\$PATH:/root/go/bin" >> /etc/profile # 写入全局变量

echo "source /etc/profile" >> ~/.bashrc # 写入本地用户刷新
source ~/.bashrc # 刷新 bash 变量
go -v # 查看 go 版本
go env -w GOPROXY=https://goproxy.cn,direct # 设置代理
go install github.com/beego/bee/v2@latest # 安装 bee
bee version # 查询 bee 版本
```