FROM ubuntu:18.04
MAINTAINER Alain Knaebel, <alain.knaebel@aknaebel.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -q -y \
      postfix postfix-mysql postfix-policyd-spf-python dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql dovecot-sieve dovecot-managesieved \
      supervisor rsyslog \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/lib/dovecot/sieve/global \

 && groupadd -g 5000 vmail \
 && useradd -g vmail -u 5000 vmail -d /var/vmail -m \
 && chmod -R o-rwx /etc/dovecot \
 && sed -i -r "/^#?compress/c\compress\ncopytruncate" /etc/logrotate.conf

##### POSTFIX
COPY ./postfix/main.cf /etc/postfix/main.cf
COPY ./postfix/master.cf /etc/postfix/master.cf
COPY ./postfix/mysql /etc/postfix/mysql

##### SUPERVISORD
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

##### DOVECOT
COPY ./dovecot/dovecot.conf /etc/dovecot/dovecot.conf
COPY ./dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext
COPY ./dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY ./dovecot/conf.d/10-logging.conf /etc/dovecot/conf.d/10-logging.conf
COPY ./dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY ./dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf
COPY ./dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
COPY ./dovecot/conf.d/15-lda.conf /etc/dovecot/conf.d/15-lda.conf
COPY ./dovecot/conf.d/20-imap.conf /etc/dovecot/conf.d/20-imap.conf
COPY ./dovecot/conf.d/20-lmtp.conf /etc/dovecot/conf.d/20-lmtp.conf
COPY ./dovecot/conf.d/20-managesieve.conf /etc/dovecot/conf.d/20-managesieve.conf
COPY ./dovecot/conf.d/auth-sql.conf.ext /etc/dovecot/conf.d/auth-sql.conf.ext

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/var/vmail"]

EXPOSE 25
EXPOSE 465
EXPOSE 587
EXPOSE 110
EXPOSE 143
EXPOSE 993
EXPOSE 995
EXPOSE 4190

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
