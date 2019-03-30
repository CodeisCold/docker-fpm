FROM php:7.2-fpm

WORKDIR /app

# 复制文件，用共享文件夹就可以了
# COPY . /app

RUN apt-get update
# 安装扩展 docker-php-ext-install [-jN] ext-name [ext-name ...]

# 安装gd库
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# pgsql支持
RUN apt-get install libpq-dev -y

RUN apt-get install libcurl3-dev libxml2-dev libreadline-dev libssl-dev zlib1g-dev -y

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
RUN docker-php-ext-install -j$(nproc) opcache mysqli pdo pdo_mysql pdo_pgsql gettext \
	bcmath soap pcntl shmop sysvmsg sysvsem sysvshm sockets zip

# 安装其他扩展
RUN pecl install xdebug \
	&& pecl install redis \
	&& pecl install yaf \
	&& pecl install swoole

# 复制 php.ini 和 fpm进程池配置文件 www.conf
COPY php.ini /usr/local/etc/php/
COPY www.conf /usr/local/etc/php-fpm.d/www.conf