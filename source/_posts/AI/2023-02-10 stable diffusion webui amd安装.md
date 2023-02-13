---
title: AMD（A卡）AI 绘画安装stable diffusion webui
date: 2023-02-10 00:00:00
urlname: amdgpu-install-stable-diffusion-webui 
tags: 
 - Python
 - Pip
 - Ubuntu
categories: ai
---
> 环境为 Ubuntu 22.04.1 LTS
# 安装 3.10 版本 python
``` bash
apt install git
apt install python3.10
# 设置别名
alias python="python3"
```

# 安装 webui
> clone 项目和设置虚拟环境
``` bash
# 从 github 拉取 webui
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
# 进入目录
cd stable-diffusion-webui
# 设置 python 虚拟环境
python -m venv venv
# source bash
source venv/bin/activate
```
> 安装 pip
```bash
python -m pip install --upgrade pip wheel

python -m pip install xformers

apt install -y miopenkernels-gfx1030-36kdb
```
> 运行 launch 自动安装依赖
```bash
TORCH_COMMAND='pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1' 
python launch.py --precision full --no-half --skip-torch-cuda-test 
```
# 下载模型
``` bash
cd models/Stable-diffusion/
# sd 1.5
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt
# sd 2.1
wget https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt
```

# 启动 webui
``` bash
HSA_OVERRIDE_GFX_VERSION=10.3.0 ./venv/bin/python webui.py --listen --enable-insecure-extension-access
```

![启动 webui](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2023/305C18A512B0160FC51946D292243A79F2D523F23063A0E3ABA5477F2F95F6F5.PNG)

![webui 首页](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2023/28F9CDD62F18C958176FA02F37A2D0E5F2DC3E11AC61289D80E96B2852684072.PNG)

![🐎骑🐎](https://gd-obj-001.gd2.qingstor.com/haruki/blog/cn/2023/77B728E8FEAF0126B816696D327D7744FA16C86CBA765C454708B723C0A4C3FA.PNG)