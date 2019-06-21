FROM php:7.2-fpm

WORKDIR /app

# 复制文件，用共享文件夹就可以了
# COPY . /app

# 安装扩展 docker-php-ext-install [-jN] ext-name [ext-name ...]

# 尽可能减少 RUN 的次数来减少 image 的层数，但是 apt-get update 很慢，最好别动这层的 RUN
# 安装gd库
RUN apt-get update \
	&& apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
# pgsql支持以及其他扩展支持
	&& apt-get install libpq-dev -y \
	&& apt-get install libcurl3-dev libxml2-dev libreadline-dev libssl-dev zlib1g-dev -y \
# opcache
# mysqli
# pdo
# pdo-mysql
# pdo-pgsql
# gettext 	用于国际化 
# bcmath 	任意精度计算
# soap 		基于xml的消息协议，通常基于htpp或smtp
# pcntl 	unix 进程控制
# shmop 	unix 共享内存
# sysvmsg 	System V消息队列
# sysvsem	System V信号量
# sysvshm 	System V共享内存
# sockets	socket通讯
# zip 		zip压缩
# mcrypt	加密扩展
# mongodb	mongodb 连接
# 以及安装其他扩展
	&& docker-php-ext-install -j$(nproc) opcache mysqli pdo pdo_mysql pdo_pgsql gettext \
	bcmath soap pcntl shmop sysvmsg sysvsem sysvshm sockets zip \
	&& pecl install xdebug \
	&& pecl install redis \
	&& pecl install yaf \
	&& pecl install swoole \
	&& apt-get install libmcrypt-dev -y \
	&& pecl install mcrypt-1.0.2 \
	&& pecl install mongodb

# imagemagick 图片处理库的安装
COPY ImageMagick.tar.gz /app
RUN mkdir /source && mv ImageMagick.tar.gz /source/ && cd /source \
	&& tar -zxf ImageMagick.tar.gz && cd /source/ImageMagick-7.0.8-45 && ./configure && make && make install \
	&& pecl install imagick

# 安装 xhprof
RUN mkdir /source/php-xhprof-extension
COPY php-xhprof-extension-master /source/php-xhprof-extension
RUN cd /source/php-xhprof-extension && phpize && ./configure && make && make install

COPY composer.phar /usr/bin/composer

# 复制 php.ini 和 fpm进程池配置文件 www.conf
# COPY php.ini /usr/local/etc/php/
# COPY www.conf /usr/local/etc/php-fpm.d/www.conf