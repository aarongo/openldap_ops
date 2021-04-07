#!/usr/bin/env bash
#########################################################################
# File Name: one-click.sh
# Author: Mode
# mail: 13692247896@163.com
# Created Time: 三  4/ 7 10:13:17 2021
# Describe: 一键式配置 Linux 服务器适配 LDAP SSH-KEY 与 SUDO
#########################################################################

LDAP_FQDN="ldap-server.host.com"
LDAP_PORT=389
LDAP_URI="ldap://${LDAP_FQDN}:${LDAP_PORT}"
LDAP_BASE_DN="dc=magic,dc=com"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
# REMOTE_ADDRESS=(192.168.1.72 192.168.1.97 192.168.1.98 192.168.1.151 192.168.1.152 192.168.1.153 192.168.1.67 192.168.1.68)
REMOTE_ADDRESS=(192.168.1.71)


sudo_conf(){

    for ip in "${REMOTE_ADDRESS[@]}"
    do
        echo -e "Copy Run Remote Server ${ip}\n"
        # 备份文件
        ssh root@"${ip}" 'cp /etc/sudo-ldap.conf /etc/sudo-ldap.conf.${DATE}'
        ssh root@"${ip}" 'cp /etc/nsswitch.conf /etc/nsswitch.conf.${DATE}'
        # 写人文件
        scp sudo-ldap.conf  root@"${ip}":/etc/sudo-ldap.conf
        ssh root@"${ip}" 'echo "sudoers:    files   ldap" >> /etc/nsswitch.conf'
        echo -e "\n"
    done
}

ssh_setup(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        echo -e "Setup SSH LDAP Run Remote Server ${ip}"
        ssh root@"${ip}" ' yum -y install openssh-ldap'
        scp magicCA.pem root@"${ip}":/etc/openldap/cacerts
        scp ldap.conf root@"${ip}":/etc/ssh/
        ssh root@"${ip}" 'echo -e "AuthorizedKeysCommand /usr/libexec/openssh/ssh-ldap-wrapper\nAuthorizedKeysCommandUser nobody\nPubkeyAuthentication yes" >> /etc/ssh/sshd_config'
        echo -e "\n"
    done
}

ssh_restart(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        echo -e "Setup SSH LDAP Run Remote Server ${ip} restart sshd"
        ssh root@"${ip}" 'systemctl restart sshd'
        echo -e "\n"
    done
}

setup_client(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        echo -e "Setup SSH LDAP Run Remote Server ${ip} Client"
        ssh root@"${ip}" 'yum install -y openldap-clients nss-pam-ldapd'
        echo -e "\n"
    done
}

client_config(){

    for ip in "${REMOTE_ADDRESS[@]}"
    do
        echo -e "Setup SSH LDAP Run Remote Server ${ip} Client"
        ssh root@"${ip}" "authconfig --enableldap --enableldapauth --enableldaptls --disablesssd --enablemd5 --enablelocauthorize  --enableshadow --ldapserver=ldap-server.magic.com --ldapbasedn='dc=magic,dc=com' --enablemkhomedir --update"
        ssh root@"${ip}" 'systemctl restart nslcd && systemctl status nslcd'
        ssh root@"${ip}" 'getent passwd liuyulong'
        echo -e "\n"
    done
    
}

main(){
    # for ip in "${REMOTE_ADDRESS[@]}"
    # do
    #     echo -e ">>>>>>> $ip\n"
    #     ping ${ip} -c 1 > /dev/null 2>&1
    #     if [[ $? -eq 0 ]]; then
    #         echo -e "ping ${ip} OK\n"
    #     else
    #         echo -e "ping ${ip} failed\n"
    #     fi
    #     # 如果需要输入密码则会导致超时
    #     gtimeout 5 ssh root@${ip} echo "SSH has passwordless access"
    #     if [[ $? -ne 0 ]]; then
    #         echo "SSH has no passwordless access"
    #     fi
    # done
    setup_client
    ssh_setup
    sudo_conf
    ssh_setup
    ssh_restart
    client_config
}

main