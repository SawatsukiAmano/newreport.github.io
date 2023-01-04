---
title: Kubernetes 1.24 内网部署
copyright: true
date: 2022-07-27 00:00:01
urlname: kubernetes-1-24-inside-install
tags: 
 - NFS
 - Nginx
 - MySQL
categories: kubernetes
---
# 环境介绍
> master：成都区 2核4G    10.0.0.17
> cd001：成都区 2核4G     10.0.0.11
> 主机：两台腾讯云轻量云，系统为CentOS Stream8，轻量云不支持EIP故不能公网搭K8s
> Kubernetes版本：V1.24.3（截至2022-08-02，当前k8s最新版本为 1.24.3）
<!-- more -->  
# Master节点安装
##  主机配置
```bash
 # 设置主机名
echo "master" > /etc/hostname
yum -y tc
yum -y update 

# 重启使master主机名生效
reboot 

echo "1" >> /proc/sys/net/ipv4/ip_forward # 开启ip转发

# 设置hosts 注意，每次重启后该文件会恢复，需要重新添加
cat >> /etc/hosts <<EOF
10.0.0.17 master
10.0.0.11 cd001
EOF

systemctl restart NetworkManager.service
```

## 配置containerd
> 将containerd作为k8s的容器引擎
```bash
# 阿里镜像源
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

cat << EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

yum install -y containerd.io --allowerasing

mkdir  -p /etc/containerd 
rm -rf /etc/containerd/config.toml

containerd config default > /etc/containerd/config.toml

sed -i 's#sandbox_image = "k8s.gcr.io/pause:#sandbox_image = "registry.aliyuncs.com/google_containers/pause:#g' /etc/containerd/config.toml
# sed -i 's/systemd_cgroup = false/systemd_cgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

systemctl enable containerd
systemctl start containerd
```
## runc命令行配置
> 检测runc、ctrcli、配置k8s源
```bash
ctr version
runc -version 

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all 
yum makecache
# k8s init时需要此应用进行网络测试
yum install -y tc   
```
## k8s组件安装
> 安装配置k8s三件套并配置
```bash
yum install -y kubectl kubelet kubeadm

# 兼容性处理 systemd
echo  'KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"' > /etc/sysconfig/kubelet

systemctl enable kubelet
systemctl start kubelet

# 配置cricl 的endpoint
crictl config runtime-endpoint unix:///run/containerd/containerd.sock
crictl config image-endpoint unix:///run/containerd/containerd.sock

# 配置k8s镜像版本（不配置默认拉去latest 最新版）
# kubeadm config images list --kubernetes-version=v1.24.3
```

## kubernetes初始化
```bash

# 错误处理
# kubeadm reset
# rm -fr  ~/.kube/config

# --apiserver-advertise-address和--control-plane-endpoint 分别为apiServer和控制面板的ip地址，内网部署使用master节点内网ip，公网部署使用master节点公网ip
kubeadm init --pod-network-cidr=10.224.0.0/16 --apiserver-advertise-address=10.0.0.17 --control-plane-endpoint=10.0.0.17 --image-repository registry.aliyuncs.com/google_containers --v=5

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

# kubeadm join 10.0.0.17:6443 --token 9t45vv.40lt4exfxmirt7q2 --discovery-token-ca-cert-hash sha256:65cfa9a08c89e81357f3e394757ebb6c6c8000020c2e7411248cac2c4ef79c2e

# 可以看到master是NotReady状态
kubectl get node -o wide

# 可以看到coredns是pending状态
kubectl get pod -A -o wide

# 之后安装calico或者flannel网络插件后会恢复正常

crictl images

crictl ps -a
```
# Node节点安装
## 主机配置
```bash
 # 设置主机名
echo "cd001" > /etc/hostname

yum install -y tc

yum -y update 

# 重启使master主机名生效
reboot 

echo "1" >> /proc/sys/net/ipv4/ip_forward # 开启ip转发

# 设置hosts 注意，每次重启后该文件会恢复，需要重新添加
cat >> /etc/hosts <<EOF
10.0.0.17 master
10.0.0.11 cd001
EOF

systemctl restart NetworkManager.service
```

## 配置containerd
```bash
# 阿里镜像源
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

cat << EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

yum install -y containerd.io --allowerasing

mkdir  -p /etc/containerd 
rm -rf /etc/containerd/config.toml

containerd config default > /etc/containerd/config.toml

 sed -i 's#sandbox_image = "k8s.gcr.io/pause:#sandbox_image = "registry.aliyuncs.com/google_containers/pause:#g' /etc/containerd/config.toml
# sed -i 's/systemd_cgroup = false/systemd_cgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

systemctl enable containerd
systemctl start containerd
```
## runc命令行配置
> 检测runc 和ctrcli、配置k8s源
```bash
ctr version
runc -version 

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all 
yum makecache

yum install -y tc
```
## k8s node组件安装
```bash
yum install -y  kubelet kubeadm

# 兼容性处理 systemd
echo  'KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"' > /etc/sysconfig/kubelet

systemctl enable kubelet
systemctl start kubelet

# 配置cricl 的endpoint
crictl config runtime-endpoint unix:///run/containerd/containerd.sock
crictl config image-endpoint unix:///run/containerd/containerd.sock

# 配置k8s镜像版本（不配置默认拉去latest 最新版）
# kubeadm config images list --kubernetes-version=v1.24.3
```

## 加入到集群
```bash

# 错误处理
# kubeadm reset
# rm -fr  ~/.kube/config

kubeadm join 10.0.0.17:6443 --token 9t45vv.40lt4exfxmirt7q2 --discovery-token-ca-cert-hash sha256:65cfa9a08c89e81357f3e394757ebb6c6c8000020c2e7411248cac2c4ef79c2e
```

# 配置K8s容器网络
> master节点执行
```bash
wget https://docs.projectcalico.org/manifests/calico.yaml --no-check-certificate
vim calico.yaml
```
> 配置yaml文件,正确的虚拟ip和网卡
```yaml
# /CALICO_IPV4POOL_CIDR 进行查找，取消注释，将值改为pod-network-cidr的值
# The default IPv4 pool to create on startup if none exists. Pod IPs will be
# chosen from this range. Changing this value after installation will have
# no effect. This should fall within `--cluster-cidr`.
 - name: CALICO_IPV4POOL_CIDR
   value: "10.244.0.0/16"

# ....
# /k8s,bgp 查找,同级新增如下
 - name: CLUSTER_TYPE
   value: "k8s,bgp"
 - name: IP_AUTODETECTION_METHOD
   value: "interface=eth0"
```
```bash
kubectl apply -f calico.yaml

# 如果执行后没反应或者拉去calio镜像过慢，可以在master和node上手动拉取镜像
# crictl pull docker.io/calico/cni
# crictl pull docker.io/calico/node
crictl pull docker.io/calico/cni:v3.23.3
crictl pull docker.io/calico/node:v3.23.3

# 检查node和containerd运行状态
kubectl get node -o wide

crictl ps -a
```
![](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2022/871EFB1C13E616DBFBEC9E43A273852E08CA7EF3090D79DBE50647C24447E91D.png)
# 配置NFS共享存储
> 由于ceph资源消耗太大，服务器数量和性能都不够，暂时只能用NFS，之后大概会在自己电脑上开虚拟机试着搭下ceph

> nfs server: cd001 10.0.0.11
```bash
yum install -y nfs-utils rpcbind # 安装nfs和rpc
systemctl enable nfs-server
sudo systemctl enable --now nfs-server
mkdir -p /srv/nfs

# 查看支持的nfs版本
sudo cat /proc/fs/nfsd/versions
userdel -r nfsuser

# nfsserver端新增一个用户，客户端操作nfs目录时会使用该用户权限进行读写
adduser -s /sbin/nologin -u 1010 -M nfsuser
# -u : 指定用户uid
# -M: --no-create-home  不创建用户home目录
# -s : --shell    指定用户的shell
passwd nfsuser 

mkdir -p /srv/nfs/
chown nfsuser.nfsuser /srv/nfs

# 所有k8s集群内ip都需要添加进去
echo "/srv/nfs/ 10.0.0.17(rw,sync,no_root_squash,anonuid=1001,anongid=1001)" > /etc/exports
echo "/srv/nfs/ 10.0.0.11(rw,sync,no_root_squash,anonuid=1001,anongid=1001)" >> /etc/exports
# rw:可读写
# ro: 只读
# no_root_squash：对root用户不压制，如果客户端以root用户写入，在服务端都映射为服务端的root用户
# root_squash： nfs服务：默认情况使用的是相反参数root_squash，如果客户端是用户root操作，会被压制成nobody用户
# all_squash:     不管客户端的使用nfs的用户是谁，都会压制成nobody用户
# insecure:   允许从客户端过来的非授权访问
# sync:     数据同步写入到内存和硬盘
# async:    数据先写入内存，不直接写入到硬盘
# anonuid: 指定uid的值，此uid必须存在于/etc/passwd中
# anongid:指定gid的值

exportfs -arv
```
> nfs client: master 10.0.0.17
```bash
# 查看公开的nfs
showmount -e 10.0.0.11

mkdir -p /mnt/nfs/cd001
# 临时挂载
# mount 10.0.0.11:/srv/nfs    /mnt/nfs/cd001

# 永久挂载
echo "10.0.0.11:/srv/nfs    /mnt/nfs/cd001  nfs4    defaults        0       0" >>  /etc/fstab
mount -a
df -TH
# k8s集群不需要挂载，写yaml后会自动进行持久挂载
umount /mnt/nfs/cd001

df -TH
```
![](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2022/A30C9689711F26C031325D2EE82625E7A353B232C0BF266975111C1C9CE4EC80.png)

# 部署Nginx和MySql
> 部署可以公网访问的nginx和持久化存储的mysql服务
> master节点
```bash
# 新增和删除命名空间
# kubectl create namespace my-namespace
# kubectl delete namespace my-namespace
# kucectl apply -f my-namespace.yaml
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
   name: public
   labels:
     name: public
```
## Nginx
```bash
cd ~
vim nginx.yaml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
```
![](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2022/564E8CA73EF28D607516A539A84B538092DDF7F4D510372E9EF52AB14DE80D36.png)
## MySQL
```bash
cd ~
vim mysql.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mysql #为该Deployment设置key为app，value为mysql的标签
  name: mysql
  namespace: default
spec:
  replicas: 1 #副本数量
  selector: #标签选择器，与上面的标签共同作用
    matchLabels: #选择包含标签app:nginx的资源
      app: mysql
  template: #这是选择或创建的Pod的模板
    metadata: #Pod的元数据
      labels: #Pod的标签，上面的selector即选择包含标签app:nginx的Pod
        app: mysql
    spec: #期望Pod实现的功能（即在pod中部署）
      containers: #生成container，与docker中的container是同一种
      - name: mysql
        image: mysql:latest #使用镜像mysql: 创建container，该container默认3306端口可访问
        ports:
        - containerPort: 3306  # 开启本容器的3306端口可访问
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: MTIzNDU2Cg== # echo "123456"  |base64
        volumeMounts: #挂载持久存储卷
        - name: mysql-data  #挂载设备的名字，与volumes[*].name 需要对应
          mountPath: /var/lib/mysql  #挂载到容器的某个路径下
          
      volumes:
      - name: mysql-data  #和上面保持一致 这是本地的文件路径，上面是容器内部的路径
        nfs:
          server: 10.0.0.11 #nfs服务器地址
          path: /srv/nfs/k8s_data/mysql  #此路径需要实现创建
---
apiVersion: v1
kind: Service # 服务类型为svc
metadata:
  name: mysql-service
  namespace: default
spec:
  selector:
    app: mysql
  ports:
  - protocol: TCP
    port: 3306  # 本service的端口
    targetPort: 3306  # 对接的容器端口
    nodePort: 32001 # nodeport即主机公网访问的端口
  type: NodePort  # svc模式为nodeport
```
```bash
kubectl apply -f mysql.yaml
# 可以正常连接mysql并且nfs服务器有持久化数据了
```
![](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2022/77781C696156A40959D4159D81D2A959A873F2A9C7AFBA72C07D9EB0DF8AF7A1.png)
![](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2022/0ED4585667FEECFEFB5A26AD2C72BE3470E6E618DBBA343D6E19402FCA5688AE.png)