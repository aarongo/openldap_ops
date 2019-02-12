sshkey_command=`which ssh-keygen`
sshkey_file_path=~/.ssh
ldap_server="ldapserver.jiumiaodai.com"
ldap_dc="$(cut -d'.' -f1 <<<"${ldap_server}")"
general_file_name=/tmp/new_addsshkey.ldif
ldap_server_passwd="/^7Ur369ahEFvWvxy6qd"

general_file(){
sshkey_key_conents=`cat ${sshkey_file_path}/${USER}.pub`
cat>${general_file_name}<<EOF
dn: uid=${USER},ou=Users,dc=${ldap_dc},dc=com
changeType: modify
add: sshPublicKey
sshPublicKey: ${sshkey_key_conents}
EOF
}

# Add sshkey to ldap server for user
add_sshkey(){
    ldapmodify -x -D "cn=Manager,dc=${ldap_dc},dc=com" -w ${ldap_server_passwd} -f ${general_file_name}
}

if [ ! -f "${sshkey_file_path}/${USER}.pub" ];then
    echo "The current user is ${USER}"
    ${sshkey_command} -f ${sshkey_file_path}/${USER} -C "${USER}@jiumiaodai.com" -N '' -q
    general_file
    add_sshkey
fi
