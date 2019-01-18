# prepare 准备安装

## 功能列表

- 配置主机 `hosts` 文件
- 增加 `epel`源
- 更新系统软件

**ansible-playbook 01-prepare.yml**

```yaml
# 所有主机进行基础准备配置
- hosts: all
  roles:
    - { role: prepare }
```
