# docker-php7.2-kitematic

Simple docker image optimised for Kitematic to run PHP 7.2-latest applications on Apache with an external path, easy to setup.

![screenshot 2018-09-26](https://user-images.githubusercontent.com/1894723/46049477-e043db80-c12e-11e8-9609-c5c8aa3b08b8.png)

## Intended workflow

1. install docker
2. get going with this readme
3. place your PHP files in connected folder on your computer to be used by the container

...

4. start the container (e.g. in Kitematic)
5. edit your files, use git or alike
6. reload your browser

...

7. stop the container
8. turn off your computer

------------------------------------
## Installation

It is recommended to use this image with Kitematic.

In Kitematic, press `+ New` and search for `docker-php7.2-kitematic` and press its `create` button.

You can read up on how to do this here:

    https://kitematic.com/docs/

if you have trouble finding it, to make it available in Kitematic and docker, you can use:

	docker pull bananaacid/docker-php7.2-kitematic


Using your own PHP files through Kitematic
------------------------------------

In Kitematic, 

if you pulled an image or deleted a container, you can create a new container from `+ New` -> `My Images` and click `create`.

1. click your new container in the containers area
2. in the Volumes area klick on `/app` to generate a local folder automatically or use `Settings -> Volumes -> /app -> Change` to select a specific folder where your PHP files will go
3. click on the preview picture (it might not update immediately) to open your page in the browser

Any errors will be shown in the container logs area (Apache logs and PHP error log). The used Ports will be visible and changeable in the `Settings` tab.


Manual usage
------------------------------------

To grap it from the online repository and use it right away:

	docker run -p 8000:80 -p 8443:443 --volume ~/my-php-app:/all  bananaacid/docker-php7.2-kitematic

to control it with Kitematic, use:

	docker run -d -p 8000:80 -p 8443:443 bananaacid/docker-php7.2-kitematic

* `-p outside:inside` can be used to setup a port into the container - http://localhost:8000 (443 is the SSL enabled port).
* `-d` will run it in the background, other wise, all container output goes to the current console. 
* `~/my-php-app`referes to the user folder from where the PHP files should be used - can also be activated within Kitematic. 
* `--name my-php-app_container` added before the image name, will create a container with a meaningful name.
* added SSL + SSL config (v1.1)


Enable .htaccess files
------------------------------------

If you app uses .htaccess files you need to pass the ALLOW_OVERRIDE environment variable

    docker run -d -p 80:80 -e ALLOW_OVERRIDE=true bananaacid/docker-php7.2-kitematic

or set it in Kitematic `Settings -> General -> Environment Variables`.


Using SSL
------------------------------------

The volume `/ssl-crt` (with `--volume ~/my-php-app-ssl:/ssl-crt`) can be used to add your own `.crt` renamed as `server.pem` and `server.key` to be used by apache. Set a port to `443` to access it.

An example to generate those files could be with `openssl req -x509 -nodes -days 10950 -newkey rsa:2048 -out server.pem -keyout server.key`

Add the `localhost.crt` or your owhn `server.pem as .crt file` to your local certificate storage to remove SSL security errors (usually double clicking it). 

If you get an error telling you `SSLCertificateFile: file '/ssl-cert/server.pem' does not exist or is empty` you have 3 options:
1. add a `server.pem` and `server.key`
2. Kitematic: remove the volume's local folder - Settings -> Volumes -> click the remove button next to `/ssl-cert`
3. command line: remove your `--volume ???:/ssl-cert` param


----------------------------------
# Improvements

Based on the work of:

* Phil Plückthun, 'docker-php-kitematic'
* Fernando Mayo <fernando@tutum.co>, 'apache-php'

... over docker-php-kitematic
----------------------------------

The following things were added/changed:

* PHP 7.2 Update, with FastCGI
* all apache / php logs are visible to the console
* revamped the default webpage placeholder to be more generic
* webpage placeholder has a link to an added phpinfo file
* makefile configured to be used for building the image and testing it
* SSL added, certificates are exchangeable



... over apache-php
----------------------------------

This fork was optimised to support Kitematic.

The following things were added/changed:

* Uses a volume instead of a static directory to expose Apache's document folder
* Running Apache in the background instead of running it in the foreground
* Exposing the access.log file to STDOUT, to make it visible in Kitematic
