#!/usr/bin/env bash

LDAPBK=ldap-$( date +%Y%m%d-%H ).ldif

BACKUPDIR=/data/ldap_backups

BACKUP_EXEC=`which slapcat`

PACKAGE=`which gzip`


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
checkdir
backuping