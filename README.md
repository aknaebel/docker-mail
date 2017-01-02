# docker-mail

## Description:

This docker image provide a [postfix](http://www.postfix.org/) and [dovecot](http://dovecot.org/) service based on [Ubuntu](https://hub.docker.com/_/ubuntu/)
This image have dependencies:
- mariadb
- memcached
- aknaebel/amavis
- aknaebel/opendkim
- aknaebel/vimbadmin

This mail image is create with the utilization of let's encrypt in mind

## Usage:

### Docker-compose:
```
version: '2'
services:
    memcached:
        image: memcached:alpine
        restart: always

    mariadb:
        image: mariadb
        restart: always
        volumes:
            - /mariadb/data:/var/lib/mysql

    amavis:
        image: aknaebel/amavis
        links:
            - mariadb
        volumes:
            - /amavis/data/amavis:/var/lib/amavis
            - /amavis/data/clamav:/var/lib/clamav
            - /amavis/data/spamassassin:/var/lib/spamassassin
        volumes:
            VIMBADMIN_PASSWORD=vimbadmin_password
            DBHOST=mariadb
            HOSTNAME=mail.example.com
        container_name: amavis
        restart: always

    mail:
        image: aknaebel/mail
        links:
            - mariadb
            - amavis
            - opendkim
        volumes:
            - /mail/data:/var/vmail
            - /etc/letsencrypt:/etc/letsencrypt
        environment:
            ADMIN_EMAIL=admin@exaple.com
            VIMBADMIN_PASSWORD=vimbadmin_password
            DBHOST=mariadb
            HOSTNAME=mail.knaebel.fr
            SSL_KEY_PATH=/etc/letsencrypt/live/##HOSTNAME##/privkey.pem
            SSL_CERT_PATH=/etc/letsencrypt/live/##HOSTNAME##/fullchain.pem
        ports:
            - "25:25"
            - "587:587"
            - "110:110"
            - "143:143"
            - "993:993"
            - "995:995"
            - "4190:4190"
        container_name: mail
        restart: always

    vimbadmin:
        image: aknaebel/vimbadmin
        links:
            - mariadb
            - mail
            - memcached
        volumes_from:
            - mail
        environment:
            VIMBADMIN_PASSWORD=vimbadmin_password
            DBHOST=mariadb
            MEMCACHE_HOST=memcached
            ADMIN_EMAIL=admin@example.com
            ADMIN_PASSWORD=admin_password
            SMTP_HOST=smtp.example.com
            APPLICATION_ENV=production
            OPCACHE_MEM_SIZE=128
        restart: always

    opendkim:
        image: aknaebel/opendkim
        volumes:
            - /opendkim/data/KeyTable:/etc/opendkim/KeyTable
            - /opendkim/data/SigningTable:/etc/opendkim/SigningTable
            - /opendkim/data/TrustedHosts:/etc/opendkim/TrustedHosts
            - /opendkim/data/keys:/tmp/keys
        container_name: opendkim
        restart: always
```

```
docker-compose up -d
```

## Mail stuff:

### Ports and protocols:

The image provide the following ports and protocols:

- SMTP (port 25)
- SMTP submission (port 587)
- POP3 (port 110
- POP3S (port 995)
- IMAP4 (port 143)
- IMAP4S (port 993)
- sieve (port 4190)

### Environment variables:
- ADMIN_EMAIL: The admin email adress of your mail service
- VIMBADMIN_PASSWORD: password for the vimdadmin user in database (see the vimbadmin image config)
- DBHOST: hostname of the databases host
- HOSTNAME: The FQDN of your mail server
- SSL_KEY_PATH: path to your private key
- SSL_CERT_PATH: path to your certificate

For the environment variables related to the other images, please see the documentation of the images.

### SSL/TlS:

The image is mainly design to work with Let's Encrypt but you can use any other SSL certificate.

### Documentation
See the [official postfix documentation](http://www.postfix.org/) and [official dovecot documention](http://dovecot.org/) to configure a specific option of your mail image
