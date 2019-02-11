#!/usr/bin/env bash

LDAPBK=ldap-$( date +%Y%m%d-%H ).ldif

BACKUPDIR=/data/ldap_backups

BACKUP_EXEC=`which slapcat`

PACKAGE=`which gzip`

REMOVE=`which rm`


checkdir(){
    if [ ! -d "$BACKUPDIR" ]; then
      mkdir -p ${BACKUPDIR}
    fi
}

backuping(){
    echo "Backup Ldap Start...."
    ${BACKUP_EXEC} -v -l ${BACKUPDIR}/${LDAPBK}

    ${PACKAGE} -9 $BACKUPDIR/$LDAPBK
}

clean_old(){
    # 删除24小时之前的备份
    find ${BACKUPDIR}/ -type f -name '*.gz' -mtime +0 -exec rm {} \;
}

checkdir
backuping
clean_old