FROM ubuntu:trusty

MAINTAINER Nabil Redmann (BananaAcid) <repo@bananaacid.de>
LABEL version="1.1"
LABEL description="Apache 2 + currently PHP 7.2 \
With support for external app folder. Using Ubuntu."
LABEL git="https://github.com/BananaAcid/docker-php7.2-kitematic"

# htaccess enabled?
ENV ALLOW_OVERRIDE False

# php.ini : upload_max_filesize, post_max_size, and memory_limit 
#ENV PHP_UPLOAD_MAX default

# Install
RUN apt-get update ; \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C ; \
	apt-get -yq install python-software-properties software-properties-common ; \
	add-apt-repository ppa:ondrej/php 2>/dev/null
# 	'-> ignore any error, we update there after

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    curl \
    apache2 \
    php7.2 php7.2-fpm php7.2-dev \
    php7.2-zip php7.2-curl php7.2-mbstring \
    php7.2-xmlrpc php7.2-gd php7.2-mysql php7.2-xml \
    php-pear php-apc \
    libapache2-mod-php7.2

#RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install libmcrypt-dev gcc make autoconf libc-dev pkg-config && \
#    pecl install mcrypt-1.0.1 && echo "extension=mcrypt.so" | tee -a /etc/php/7.2/apache2/conf.d/mcrypt.ini && \
#    /usr/sbin/phpenmod mcrypt

RUN rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod proxy_fcgi setenvif && a2enconf php7.2-fpm

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# VOLUME order will change random on reload due to settings changes ...

# Configure /app volume with sample app
RUN rm -rf /var/www/html
ADD sample/ /app/
RUN ln -s /app /var/www/html
VOLUME ["/app"]
EXPOSE 80

# enable SSL, 30 Years, https://letsencrypt.org/docs/certificates-for-localhost/
# directly changing apache config to volume path, so missing pem file error will show that exact path
RUN mkdir /ssl-cert && \
	(printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" > /tmp/ext.tmp &&  openssl req -x509 -nodes -days 10950 -newkey rsa:2048 -out /ssl-cert/server.pem -keyout /ssl-cert/server.key -subj '/CN=localhost' -extensions EXT -config /tmp/ext.tmp && rm /tmp/ext.tmp) && \
	ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/000-default-ssl.conf && \
	sed -i "s/\/etc\/ssl\/certs\/ssl-cert-snakeoil/\/ssl-cert\/server/g" /etc/apache2/sites-available/default-ssl.conf && \
	sed -i "s/\/etc\/ssl\/private\/ssl-cert-snakeoil/\/ssl-cert\/server/g" /etc/apache2/sites-available/default-ssl.conf && \
	a2enmod ssl
VOLUME ["/ssl-cert"]
EXPOSE 443

WORKDIR /app
CMD ["/run.sh"]
