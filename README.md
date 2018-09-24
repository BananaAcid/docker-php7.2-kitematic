docker-php7.2.10-kitematic
==========================
Changes:
- PHP 7.2.10 Update and updates from https://github.com/tutumcloud/apache-php
- PHP Error to output (not Apache log)



docker-php-kitematic
================

Simple docker image optimised for Kitematic to run PHP applications on Apache

Based on the (awesome) work of Fernando Mayo <fernando@tutum.co>

Installation
------------

It is recommended to use this image with Kitematic. You can read up on how to do this here:

    https://kitematic.com/docs/

Improvements over tutum-docker-php
----------------------------------

This fork was optimised to support Kitematic.

The following things were added/changed:

* Uses a volume instead of a static directory to expose Apache's document folder
* Running Apache in the background instead of running it in the foreground
* Exposing the access.log file to STDOUT, to make it visible in Kitematic
