#!/usr/bin/env bash
#########################################################################
# File Name: one-click.sh
# Author: Mode
# mail: 13692247896@163.com
# Created Time: 三  4/ 7 10:13:17 2021
# Describe: 一键式配置 Linux 服务器适配 LDAP SSH-KEY 与 SUDO
#########################################################################

LDAP_FQDN="ldap-server.magic.com"
LDAP_URI="ldap://${LDAP_FQDN}"
LDAP_BASE_DN="dc=magic,dc=com"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
# REMOTE_ADDRESS=(192.168.1.72 192.168.1.97 192.168.1.98 192.168.1.151 192.168.1.152 192.168.1.153 192.168.1.67 192.168.1.68)
REMOTE_ADDRESS=(192.168.1.153)


install_ldap_client(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        ssh root@${ip} "yum install -y openldap-clients nss-pam-ldapd > /dev/null"
    done
}

setup_client_authconfig(){
    # 配置使用 TLS
    ssh root@${ip} "systemctl restart nslcd && systemctl status nslcd"
    ssh root@${ip} "[[ ! -d /etc/openldap/cacerts ]] && mkdir /etc/openldap/cacerts"
    scp magicCA.pem root@${ip}:/etc/openldap/cacerts/magicCA.pem
    ssh root@${ip} "authconfig --enableldap --enableldapauth --enableldaptls --ldapserver=${LDAP_URI} --ldapbasedn=${LDAP_BASE_DN} --enablemkhomedir --update"
}

config_rsync(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        scp ldap.conf root@${ip}:/etc/openldap/ldap.conf
        scp nslcd.conf root@${ip}:/etc/nslcd.conf
        scp nsswitch.conf root@${ip}:/etc/nsswitch.conf
        scp sudo-ldap.conf root@${ip}:/etc/sudo-ldap.conf
    done
}

setup_client_ssh(){
    for ip in "${REMOTE_ADDRESS[@]}"
    do
        ssh root@${ip} "yum -y install openssh-ldap > /dev/null"
        scp ssh-ldap.conf root@${ip}:/etc/ssh/ldap.conf
        ssh root@${ip} 'echo -e "AuthorizedKeysCommand /usr/libexec/openssh/ssh-ldap-wrapper\nAuthorizedKeysCommandUser nobody\nPubkeyAuthentication yes" >> /etc/ssh/sshd_config'
        ssh root@${ip} "systemctl restart sshd && systemctl enable sshd"
    done
    
}


install_ldap_client

config_rsync

setup_client_ssh

setup_client_authconfig