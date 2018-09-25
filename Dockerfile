FROM ubuntu:trusty

MAINTAINER Nabil Redmann (BananaAcid) <repo@bananaacid.de>
LABEL version="1.0"
LABEL description="Apache 2 + currently PHP 7.2 \
With support for external app folder. Using Ubuntu."
LABEL git="https://github.com/BananaAcid/docker-php7.2-kitematic"

# Install
RUN apt-get update ; \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C ; \
	apt-get -yq install python-software-properties software-properties-common ; \
	add-apt-repository ppa:ondrej/php 2>/dev/null
# 	'-> ignore any error, we update there after

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    curl \
    apache2 \
    php7.2 php-pear php7.2-fpm php7.2-dev \
    php7.2-zip php7.2-curl php7.2-mbstring \
    php7.2-xmlrpc php7.2-gd php7.2-mysql php7.2-xml \
    php-apc \
    libapache2-mod-php7.2

#RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install libmcrypt-dev gcc make autoconf libc-dev pkg-config && \
#    pecl install mcrypt-1.0.1 && echo "extension=mcrypt.so" | sudo tee -a /etc/php/7.2/apache2/conf.d/mcrypt.ini && \
#    /usr/sbin/phpenmod mcrypt

RUN rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod proxy_fcgi setenvif && a2enconf php7.2-fpm

ENV ALLOW_OVERRIDE **False**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app volume with sample app
RUN rm -rf /var/www/html
VOLUME ["/app"]
ADD sample/ /app/
RUN ln -s /app /var/www/html

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
