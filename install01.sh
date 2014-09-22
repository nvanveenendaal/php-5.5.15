#!/bin/bash

# Make sure you are up to date
yum -y update && yum -y install wget

# Install EPEL repository
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Get us a clean working directory
mkdir /php
cd /php

# Install PHP dependencies
yum -y install gcc make gcc-c++ cpp kernel-headers.x86_64 libxml2-devel openssl-devel \
    bzip2-devel libjpeg-devel libpng-devel freetype-devel openldap-devel postgresql-devel \
    aspell-devel net-snmp-devel libxslt-devel libc-client-devel libicu-devel gmp-devel curl-devel \
    libmcrypt-devel unixODBC-devel pcre-devel sqlite-devel db4-devel enchant-devel libXpm-devel \
    mysql-devel readline-devel libedit-devel recode-devel libtidy-devel libtool-ltdl-devel
    
# Download PHP
wget http://nl1.php.net/get/php-5.5.15.tar.gz/from/this/mirror -O /php/php-5.5.15.tar.gz

# Extract PHP
tar xzvf /php/php-5.5.15.tar.gz

# Move to unpacked folder
cd /php/php-5.5.15

# Configure PHP build script
./configure \
    --with-libdir=lib64 \
    --cache-file=./config.cache \
    --prefix=/php/php-5.5.15 \
    --with-config-file-path=/php/php-5.5.15/etc \
    --disable-debug \
    --with-pic \
    --disable-rpath \
    --with-bz2 \
    --with-curl \
    --with-freetype-dir=/php/php-5.5.15 \
    --with-png-dir=/php/php-5.5.15 \
    --enable-gd-native-ttf \
    --without-gdbm \
    --with-gettext \
    --with-gmp \
    --with-iconv \
    --with-jpeg-dir=/php/php-5.5.15 \
    --with-openssl \
    --with-pspell \
    --with-pcre-regex \
    --with-zlib \
    --enable-exif \
    --enable-ftp \
    --enable-sockets \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-sysvmsg \
    --enable-wddx \
    --with-kerberos \
    --with-unixODBC=/usr \
    --enable-shmop \
    --enable-calendar \
    --with-libxml-dir=/php/php-5.5.15 \
    --enable-pcntl \
    --with-imap \
    --with-imap-ssl \
    --enable-mbstring \
    --enable-mbregex \
    --with-gd \
    --enable-bcmath \
    --with-xmlrpc \
    --with-ldap \
    --with-ldap-sasl \
    --with-mysql=/usr \
    --with-mysqli \
    --with-snmp \
    --enable-soap \
    --with-xsl \
    --enable-xmlreader \
    --enable-xmlwriter \
    --enable-pdo \
    --with-pdo-mysql \
    --with-pear=/php/php-5.5.15/pear \
    --with-mcrypt \
    --without-pdo-sqlite \
    --with-config-file-scan-dir=/php/php-5.5.15/php.d \
    --without-sqlite3 \
    --enable-intl \
    --enable-opcache
    
# Build & Install
make && make install

# Create a default php.ini
mkdir /php/php-5.5.15/etc
cp -a /etc/php.ini /php/php-5.5.15/etc/php.ini

# Set the timezone
timezone=$(grep -oP '(?<=")\w+/\w+' /etc/sysconfig/clock)
sed -i "s#;date.timezone =#date.timezone = $timezone#" /php/php-5.5.15/etc/php.ini

# Register with Plesk
/usr/local/psa/bin/php_handler \
    --add \
    -displayname "5.5.15" \
    -path /php/php-5.5.15/bin/php-cgi \
    -phpini /php/php-5.5.15/etc/php.ini \
    -type fastcgi \
    -id "fastcgi-5.5.15"