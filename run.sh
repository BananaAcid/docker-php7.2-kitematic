#!/bin/bash
chown www-data:www-data /app -R
rm -f /var/log/apache2/*


if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi

. /etc/apache2/envvars

apache2
exec tail -f /var/log/apache2/* 2>/dev/null
