---
title:  Linux 配置 SSH Key
copyright: true
date: 2023-03-30 00:00:01
urlname: linux-setting-ssh-key
keywords: ssh openssh linux ubuntu centos
tags: 
 - SSH
categories: linux
---
1. putty 生成 key
2. 允许 root 密钥登陆
   1. > /etc/ssh/sshd_config 
   2. 取消注释或新增行：PermitRootLogin prohibit-password
3. 上传公钥
   1. > ~/.ssh/authorized_keys 
4. 重启 ssh
   1. > systemcetl restart sshd