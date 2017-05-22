# elabftw in docker, without MySQL
FROM alpine:edge
MAINTAINER Nicolas CARPi <nicolas.carpi@curie.fr>

# select version or branch here
ENV ELABFTW_VERSION hypernext

# install nginx and php-fpm
RUN apk upgrade -U -a && apk add --update \
    autoconf \
    build-base \
    coreutils \
    curl \
    ghostscript \
    git \
    graphicsmagick-dev \
    openssl \
    #libressl \
    libtool \
    nginx \
    openjdk8-jre \
    php7 \
    php7-curl \
    php7-ctype \
    php7-dev \
    php7-dom \
    php7-gettext \
    php7-fileinfo \
    php7-fpm \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-opcache \
    php7-openssl \
    php7-pdo_mysql \
    php7-pear \
    php7-phar \
    php7-session \
    php7-zip \
    php7-zlib \
    supervisor && rm -rf /var/cache/apk/*

# install gmagick
RUN pecl install gmagick-2.0.4RC1 && echo "extension=gmagick.so" >> /etc/php7/php.ini

# nginx will run on port 443
EXPOSE 443

# copy configuration and run script
COPY ./src/nginx/ /etc/nginx/
COPY ./src/supervisord.conf /etc/supervisord.conf
COPY ./src/run.sh /run.sh

# start
ENTRYPOINT exec /run.sh

# define mountable directories
VOLUME /elabftw
VOLUME /ssl

LABEL org.label-schema.name="elabftw" \
    org.label-schema.description="Run nginx and php-fpm to serve elabftw" \
    org.label-schema.url="https://www.elabftw.net" \
    org.label-schema.vcs-url="https://github.com/elabftw/elabimg" \
    org.label-schema.version=$ELABFTW_VERSION \
    org.label-schema.schema-version="1.0"
