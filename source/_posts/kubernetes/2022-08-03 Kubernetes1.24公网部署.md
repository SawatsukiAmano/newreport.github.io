---
title: Kubernetes1.24公网部署
copyright: true
date: 2022-08-03 00:00:01
urlname: kubernetes_1_24_public_install
tags: 
 - CloudComputing
categories: kubernetes
---

# 环境介绍
> master：成都区 2核4G  
> cd001：成都区 2核4G 
> hk001: 香港区 2核4G
> sg001: 新加坡 2核4G
> 主机：四台腾讯云服务器，系统为CentOS Stream9
> Kubernetes版本：V1.24.3（截至2022-08-03，当前k8s最新版本为 1.24.3）
<!-- more -->  


#### 由于集群在公网搭建，所以需要添加一张虚拟网卡(公网ip，仅master节点，如果集群为内网搭建，可省略该步骤）
tee /etc/sysconfig/network-scripts/ifcfg-eth0:1 <<-'EOF'
DEVICE=eth0:1
ONBOOT=yes
BOOTPROTO=static
IPADDR=公网IP
NETMASK=255.255.255.0
EOF