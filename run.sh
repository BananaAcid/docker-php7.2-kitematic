#!/bin/bash
chown www-data:www-data /app -R
rm -f /var/log/apache2/*
chown www-data:www-data /var/log/apache2 -R


case "$ALLOW_OVERRIDE" in 
    "True"|"true"|"TRUE"|"1"|"on"|"all"|"All"|"ALL")  
        sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
        a2enmod rewrite
        export ALLOW_OVERRIDE=All
        ;; 
    *) 
        unset ALLOW_OVERRIDE
        ;; 
esac


case "$XDEBUG_ENABLE" in 
    "True"|"true"|"TRUE"|"1"|"on")  

        printf ";XDebug\nzend_extension=\"`find / -name xdebug.so`\"\nxdebug.remote_port=9001\nxdebug.remote_log=\"/var/log/apache2/xdebug.log\"\nxdebug.remote_connect_back=1\nxdebug.remote_enable=1\nxdebug.idekey=\"$XDEBUG_IDEKEY\"\nxdebug.remote_mode=req\nxdebug.remote_timeout=2000\n" > /etc/php/7.2/apache2/conf.d/30-xdebug.ini

        case "$XDEBUG_AUTOSTART" in
            "True"|"true"|"TRUE"|"1"|"on")
                printf "xdebug.remote_autostart=1\n" >> /etc/php/7.2/apache2/conf.d/30-xdebug.ini
                ;;
            *)
                printf "xdebug.remote_autostart=0\n" >> /etc/php/7.2/apache2/conf.d/30-xdebug.ini
                ;;  
        esac
        ;;
esac


. /etc/apache2/envvars

apache2
exec tail -f /var/log/apache2/* 2>/dev/null
