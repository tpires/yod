# Yeoman in docker #

Yod is a [docker](https://docker.com) image built to help front-end developers, resolving yeoman's dependencies and including bower, grunt and gulp.
When executing yod for the first time it'll build a new image (yod:dev) that will be used to execute npm, node, bower, grunt and gulp.

## Pre-requisites ##
### Mac OS X ###
* boot2docker 1.3.1 (>=)

### Linux ###
* docker 1.3.0 (>=)

## How to build ##
### From repository ###
	$ git clone https://github.com/tpires/yod.git
	$ cd yod
	$ docker build -t yod .
	$ sudo cp yod /usr/local/bin/
### From Docker Hub ###
	$ docker pull tpires/yod:latest
	$ curl https://raw.githubusercontent.com/tpires/yod/master/yod -o /usr/local/bin/yod

## How to use
	$ # create your project directory and launch yod script
	$ mkdir myproject && cd myproject
	$ yod

### Extras ###
After your first yod setup you can use the following commands on your machine:

	$ npm
	$ node
	$ nodejs
	$ bower
	$ grunt
	$ gulp

## Notes ##
### Mac OS X ###
* docker 1.3.x can share volumes with boot2docker VM, but only on /Users/*
* If you're using 'localhost' on your code, when you try to access from your host don't forget you must use boot2docker IP. Or manually map your host ports to boot2docker VM.

## Credits ##
* [Yeoman](http://yeoman.io)

## Community ##
The following amazing people live on planet Earth and have contributed to yod.

* Filipa Lacerda (@Lacerda)
* Luis Couto (@Couto)
