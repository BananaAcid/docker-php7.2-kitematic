FROM ubuntu:trusty
MAINTAINER Nabil Redmann (BananaAcid) <repo@bananaacid.de>
LABEL version="1.0"
LABEL description="Fixed for Apache 2 + PHP 5 \
With support for external app folder. Using Ubuntu."
LABEL git="https://github.com/BananaAcid/docker-php7.2-kitematic"

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN /usr/sbin/php5enmod mcrypt

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

ENV PHP_VERSION 7.2.10
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
