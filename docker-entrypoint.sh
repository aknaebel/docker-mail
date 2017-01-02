#!/bin/sh

sed -i "s|##SSL_CERT_PATH##|${SSL_CERT_PATH}|g" /etc/postfix/main.cf
sed -i "s|##SSL_KEY_PATH##|${SSL_KEY_PATH}|g" /etc/postfix/main.cf
sed -i "s/##HOSTNAME##/${HOSTNAME}/g" /etc/postfix/main.cf

sed -i "s/##VIMBADMIN_PASSWORD##/${VIMBADMIN_PASSWORD}/g" /etc/postfix/mysql/virtual_alias_maps.cf
sed -i "s/##DBHOST##/${DBHOST}/g" /etc/postfix/mysql/virtual_alias_maps.cf

sed -i "s/##VIMBADMIN_PASSWORD##/${VIMBADMIN_PASSWORD}/g" /etc/postfix/mysql/virtual_domains_maps.cf
sed -i "s/##DBHOST##/${DBHOST}/g" /etc/postfix/mysql/virtual_domains_maps.cf

sed -i "s/##VIMBADMIN_PASSWORD##/${VIMBADMIN_PASSWORD}/g" /etc/postfix/mysql/virtual_mailbox_maps.cf
sed -i "s/##DBHOST##/${DBHOST}/g" /etc/postfix/mysql/virtual_mailbox_maps.cf

sed -i "s/##DBHOST##/${DBHOST}/g" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s/##VIMBADMIN_PASSWORD##/${VIMBADMIN_PASSWORD}/g" /etc/dovecot/dovecot-sql.conf.ext

sed -i "s|##SSL_CERT_PATH##|${SSL_CERT_PATH}|g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s|##SSL_KEY_PATH##|${SSL_KEY_PATH}|g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/##HOSTNAME##/${HOSTNAME}/g" /etc/dovecot/conf.d/10-ssl.conf

sed -i "s/##ADMIN_EMAIL##/${ADMIN_EMAIL}/g" /etc/dovecot/conf.d/15-lda.conf
sed -i "s/##HOSTNAME##/${HOSTNAME}/g" /etc/dovecot/conf.d/15-lda.conf

chown -R vmail:vmail /var/vmail \
 && chown -R vmail:dovecot /etc/dovecot \
 && chmod -R o-rwx /etc/dovecot

exec "$@"
