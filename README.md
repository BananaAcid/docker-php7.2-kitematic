# docker-php7.2-kitematic

Simple docker image optimised for Kitematic to run PHP 7.2-latest applications on Apache with an external path, easy to setup.

Based on the work of:

* Phil Plückthun, 'docker-php-kitematic'
* Fernando Mayo <fernando@tutum.co>, 'apache-php'


------------------------------------
## Installation
It is recommended to use this image with Kitematic.

In Kitematic, press `+ New` and search for `docker-php7.2-kitematic`.

You can read up on how to do this here:

    https://kitematic.com/docs/

if you have trouble finding it, to make it available in Kitematic and docker, you can use:

	docker pull bananaacid/docker-php7.2-kitematic


Manual usage
------------------------------------

To grap it from the online repository and use it:

	docker run -p 8000:80 --volume ~/my-php-app:/all  bananaacid/docker-php7.2-kitematic

to control it with Kitematic, use:

	docker run -d -p 8000:80  bananaacid/docker-php7.2-kitematic

* `-d` will run it in the background, other wise, all container output goes to the current console. 
* `~/my-php-app`referes to the user folder from where the php files should be used - can also be activated within in Kitematic. 
* `--name my-php-app_container` added before the image name, will create a container with a meaningful name.


Enable .htaccess files
------------------------------------

If you app uses .htaccess files you need to pass the ALLOW_OVERRIDE environment variable

    docker run -d -p 80:80 -e ALLOW_OVERRIDE=true bananaacid/docker-php7.2-kitematic

or set it in Kitematic `Settings -> General -> Environment Variables`.




----------------------------------
# Improvements

over docker-php-kitematic
----------------------------------

The following things were added/changed:

* PHP 7.2 Update, with FastCGI
* all apache / php logs are visible to the console
* intro page has a link to an added phpinfo file
* revamped the default placeholder to be more generic
* makefile configured to be used for building the image and testing it



over apache-php
----------------------------------

This fork was optimised to support Kitematic.

The following things were added/changed:

* Uses a volume instead of a static directory to expose Apache's document folder
* Running Apache in the background instead of running it in the foreground
* Exposing the access.log file to STDOUT, to make it visible in Kitematic
