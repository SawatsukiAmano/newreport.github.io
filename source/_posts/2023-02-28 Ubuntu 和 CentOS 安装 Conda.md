---
title:  Ubuntu 和 CentOS 安装 Conda 和 GCC 环境
copyright: true
date: 2023-02-28 00:00:00
urlname: ubuntu-amd-centos-install-conda
tags: 
 - Python
 - Conda
 - Pip
categories: linux
---
# 安装 conda
> conda 是一个 python 的包和环境管理工具。  
官网：https://conda.io/  
> Download：https://docs.conda.io/projects/conda/en/stable/user-guide/install/linux.html  

```bash
 wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
 
 bash Anaconda3-2022.10-Linux-x86_64.sh 
```
> 之后回车 yes 回车即可

# 安装 gcc

## CentOS
```bash
yum check-update
yum update
yum groupinstall "Development Tools"
yum install gcc-c++
gcc--version
```

## Ubuntu
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get  build-depgcc
sudo apt-get  install  build-essential
gcc--version
```