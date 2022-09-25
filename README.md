docker-ubuntu-novnc-puppeteer:latest
===================

**Make running headful Puppeteer bots easy with NoVNC and Docker.**

Available on [Docker hub](https://hub.docker.com/r/franciskim/ubuntu-novnc-puppeteer)

The source files are available on [GitHub](https://github.com/franciskim/docker-ubuntu-novnc-puppeteer)

Based on the work by [Doro Wu](https://github.com/fcwu), adapted by [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)
 see on [Docker](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/) and [Docker](https://hub.docker.com/r/fredblgr/ubuntu-novnc), respectively.


Typical usage is:

```
docker run -p 6080:80 -e RESOLUTION=1700x950 -v /Your/Puppeteer/Workspace:/root/Desktop/scripts franciskim/ubuntu-novnc-puppeteer:latest puppeteer-script.js
```

This command will allow you to easily mount your workspace on the Docker instance for easy running of your Puppeteer bot. It will also run `node puppeteer-script.js` and you will be able to view your Puppeteer bot working via the VNC server at `http://localhost:6080` 🔥

Protip
----------------
```
async function main() {
    try {
        let settings = {
            channel: 'chrome',
            headless: false,
            viewport: null,
            devtools: false,
            args: [
                '--start-maximized',
                '--disable-popup-blocking',
                `--disable-extensions-except=${process.cwd()}/extensions/Coinbase-Wallet-extension,${process.cwd()}/extensions/Ethereum-Gas-Price-Extension`
            ]
        }
        if (require('os').userInfo().username == 'root') {
            settings.args.push('--no-sandbox');
        }
```
Instantiating your headful Puppeteer bot like above will allow the the same bot to be easily run on different environments.


Very Quick Start
----------------
Run ```./start.sh```, you will have Ubuntu 22.04 in your browser, with the current working directory mounted on /workspace. The container will be removed when it stops, so save your work in /workspace if you want to keep it.

There is a ```start.ps1``` for the PowerShell of Windows. You may have to allow the execution of scripts with the command:

```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.

Quick Start
-------------------------
Run the docker container and access with port `6080`

```
docker run -p 6080:80 -e RESOLUTION=1700x950 franciskim/ubuntu-novnc-puppeteer:latest
```

Browse http://127.0.0.1:6080/


VNC Viewer
------------------

Forward VNC service port 5900 to host by

```
docker run -p 6080:80 -p 5900:5900 franciskim/ubuntu-novnc-puppeteer:latest
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword franciskim/ubuntu-novnc-puppeteer:latest
```

A prompt will ask password either in the browser or vnc viewer.

HTTP Base Authentication
---------------------------

This image provides base access authentication of HTTP via `HTTP_PASSWORD`

```
docker run -p 6080:80 -e HTTP_PASSWORD=mypassword franciskim/ubuntu-novnc-puppeteer:latest
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
docker run -p 6081:443 -e SSL_PORT=443 -v ${PWD}/ssl:/etc/nginx/ssl franciskim/ubuntu-novnc-puppeteer:latest
```

Screen Resolution
------------------

The Resolution of virtual desktop adapts browser window size when first connecting the server. You may choose a fixed resolution by passing `RESOLUTION` environment variable, for example

```
docker run -p 6080:80 -e RESOLUTION=1920x1080 franciskim/ubuntu-novnc-puppeteer:latest
```

Default Desktop User
--------------------

The default user is `root`. You may change the user and password respectively by `USERNAME`, `USERID` and `PASSWORD` environment variables, for example,

```
docker run -p 6080:80 -e USERNAME=`id -n -u` -e USERID=`id -u` -e PASSWORD=password franciskim/ubuntu-novnc-puppeteer:latest
```

This way, you will have the same name and uid in the container as on the host machine, which is very convenient when you mount a directory in the container using ```--volume```.


Deploy to a subdirectory (relative url root)
--------------------------------------------

You may deploy this application to a subdirectory, for example `/some-prefix/`. You then can access application by `http://127.0.0.1:6080/some-prefix/`. This can be specified using the `RELATIVE_URL_ROOT` configuration option like this

```
docker run -p 6080:80 -e RELATIVE_URL_ROOT=some-prefix franciskim/ubuntu-novnc-puppeteer:latest
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
