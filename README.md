# Yeoman in docker #

## Pre-requisites ##
### Mac OS X ###
* boot2docker 1.3.1 (>=)

### Linux ###
* docker 1.2.0 (>=)

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
