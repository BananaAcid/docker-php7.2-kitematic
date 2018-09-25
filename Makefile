#usage `make` or `make image` or `make run` or `make rmi`
all: image run

# build the image for distribution
image:
	docker build -t bananaacid/docker-php7_2-kitematic .

# test the image on port 8000
run:
	docker run -p 8000:80 -d bananaacid/docker-php7_2-kitematic

# just remove the image
rmi:
	docker rmi bananaacid/docker-php7_2_10-kitematic --force
	echo "reopen Kitematic (BETA) to update correctly"

# stop container and delete its image from docker
die:
	docker rm `docker stop \`docker ps -a -q  --filter ancestor=bananaacid/docker-php7_2-kitematic\``
	#docker kill `docker ps -a -q  --filter ancestor=bananaacid/docker-php7_2_10-kitematic`
	docker rmi bananaacid/docker-php7_2_10-kitematic --force
	echo "reopen Kitematic (BETA) to update correctly"