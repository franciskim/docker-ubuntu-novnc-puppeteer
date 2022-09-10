docker-ubuntu_22-04-novnc
===================

Docker image to provide HTML5 VNC interface to access a Ubuntu 22.04 LXDE desktop environment that is optimised for running headful Puppeteer instances.

Available on [Docker hub](https://hub.docker.com/r/franciskim/ubuntu-novnc-puppeteer)

The source files are available on [GitHub](https://github.com/Frederic-Boulanger-UPS/docker-ubuntu-novnc)

Based on the work by [Doro Wu](https://github.com/fcwu), adapted by [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)
 see on [Docker](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/) and [Docker](https://hub.docker.com/r/fredblgr/ubuntu-novnc), respectively.


Typical usage is:

```
docker run --rm -d -p 6080:80 -v $PWD:/workspace:rw -e USERNAME=username -e USERID=userid -e RESOLUTION=1700x950 --name ubuntu-novnc franciskim/ubuntu-novnc-puppeteer:22.04
```

Very Quick Start
----------------
Run ```./start.sh```, you will have Ubuntu 22.04 in your browser, with the current working directory mounted on /workspace. The container will be removed when it stops, so save your work in /workspace if you want to keep it.

There is a ```start.ps1``` for the PowerShell of Windows. You may have to allow the execution of scripts with the command:

```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.

Quick Start
-------------------------
Run the docker container and access with port `6080`

```
docker run -p 6080:80 franciskim/ubuntu-novnc-puppeteer:22.04
```

Browse http://127.0.0.1:6080/


VNC Viewer
------------------

Forward VNC service port 5900 to host by

```
docker run -p 6080:80 -p 5900:5900 franciskim/ubuntu-novnc-puppeteer:22.04
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword franciskim/ubuntu-novnc-puppeteer:22.04
```

A prompt will ask password either in the browser or vnc viewer.

HTTP Base Authentication
---------------------------

This image provides base access authentication of HTTP via `HTTP_PASSWORD`

```
docker run -p 6080:80 -e HTTP_PASSWORD=mypassword franciskim/ubuntu-novnc-puppeteer:22.04
```

SSL
--------------------

To connect with SSL, generate self signed SSL certificate first if you don't have it

```
mkdir -p ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt
```

Specify SSL port by `SSL_PORT`, certificate path to `/etc/nginx/ssl`, and forward it to 6081

```
docker run -p 6081:443 -e SSL_PORT=443 -v ${PWD}/ssl:/etc/nginx/ssl franciskim/ubuntu-novnc-puppeteer:22.04
```

Screen Resolution
------------------

The Resolution of virtual desktop adapts browser window size when first connecting the server. You may choose a fixed resolution by passing `RESOLUTION` environment variable, for example

```
docker run -p 6080:80 -e RESOLUTION=1920x1080 franciskim/ubuntu-novnc-puppeteer:22.04
```

Default Desktop User
--------------------

The default user is `root`. You may change the user and password respectively by `USERNAME`, `USERID` and `PASSWORD` environment variables, for example,

```
docker run -p 6080:80 -e USERNAME=`id -n -u` -e USERID=`id -u` -e PASSWORD=password franciskim/ubuntu-novnc-puppeteer:22.04
```

This way, you will have the same name and uid in the container as on the host machine, which is very convenient when you mount a directory in the container using ```--volume```.


Deploy to a subdirectory (relative url root)
--------------------------------------------

You may deploy this application to a subdirectory, for example `/some-prefix/`. You then can access application by `http://127.0.0.1:6080/some-prefix/`. This can be specified using the `RELATIVE_URL_ROOT` configuration option like this

```
docker run -p 6080:80 -e RELATIVE_URL_ROOT=some-prefix franciskim/ubuntu-novnc-puppeteer:22.04
```

NOTE: this variable should not have any leading and trailing slash (/)

Use as a base image
-------------------
You may use this image as a base image to benefit from the GUI in a web browser, and install additional software.
You can customize the startup process of the container by adding shell scripts to the ```/etc/startup/``` folder. Any readable file with extension ```.sh``` placed in this folder will be sourced at this end of the startup process. You may use the following variables in your script:
* ```$USER``` is the user name of the user connected to the session
* ```$HOME``` is the home directory of that user
* ```$RESOLUTION```, if defined, is the resolution of the display, in the form ```<width>x<height>``` in pixels.


License
==================

Original work by [Doro Wu](https://github.com/fcwu)

Adapted by [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)

Adapted again by [Francis Kim](https://github.com/franciskim)
