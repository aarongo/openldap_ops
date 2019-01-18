# Clent Add

## 功能
- 引用`prepare`
-  引用`chrony`
-  引用`client`
-  开启`clien`支持`ssh`、`sudo`

**support: true** 是否开启 `sudo` `ssh`支持

- **ansible-playbook 06-addclient.yml**

    ```yaml
    - hosts: new_client
      roles:
        - { role: prepare}
        - { role: chrony, CHRONY_NTP: true}
        - { role: ldap_client, install_client: true}
        - { role: support_ssh_sudo, support: true}
    ```