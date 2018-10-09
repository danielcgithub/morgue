FROM php:5-fpm-alpine
MAINTAINER Triptease (ops@triptease.com)

EXPOSE 80 443
ENTRYPOINT ["/bin/sh","/usr/src/app/run.sh"]

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV MORGUE_ENVIRONMENT docker

RUN apk add nginx --update-cache

RUN docker-php-ext-install pdo pdo_mysql

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    && php composer-setup.php
    && php -r "unlink('composer-setup.php');"


COPY . /usr/src/app
RUN ln -sf /usr/src/app/nginx/site.conf /etc/nginx/nginx.conf \
	&& php composer.phar update
