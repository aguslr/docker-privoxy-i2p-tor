[aguslr/docker-privoxy-i2p-tor][1]
==========================

[![docker-pulls](https://img.shields.io/docker/pulls/aguslr/privoxy-i2p-tor)](https://hub.docker.com/r/aguslr/privoxy-i2p-tor) [![image-size](https://img.shields.io/docker/image-size/aguslr/privoxy-i2p-tor/latest)](https://hub.docker.com/r/aguslr/privoxy-i2p-tor)


This *Docker* image sets up *Privoxy* to be used as a proxy that can redirect
traffic through the *I2P* or *Tor* networks.

> **[Privoxy][2]** is a free non-caching web proxy with filtering capabilities
> for enhancing privacy, manipulating cookies and modifying web page data and
> HTTP headers before the page is rendered by the browser.

> **[I2P][3]** is an anonymous network layer that allows for
> censorship-resistant, peer-to-peer communication by encrypting the user's
> traffic, and sending it through a volunteer-run network of roughly 55,000
> computers distributed around the world.

> **[Tor][4]** is a free and open-source software for enabling anonymous
> communication by directing Internet traffic through a free, worldwide,
> volunteer overlay network to conceal a user's location and usage from anyone
> performing network surveillance or traffic analysis.


Installation
------------

To use *Privoxy-I2P-Tor* for improved privacy, follow these steps:

1. Clone and start the container:

       docker run -p 8118:8118 -p 4447:4447 -p 9050:9050 \
         docker.io/aguslr/privoxy-i2p-tor:latest

2. Change your [Web browser's proxy settings][5] to point to the appropriate
   proxy. Here we have 3 routing options:
    1. All traffic through *Tor*: use *SOCKSv5* proxy with `127.0.0.1:9050`.
    2. All traffic through *I2P*: use *SOCKSv5* proxy with `127.0.0.1:4447`.
    3. Only *[.i2p][6]* sites through *I2P*, *[.onion][7]* sites through *Tor*:
       use *HTTP* proxy with `127.0.0.1:8118`.

Using a *SOCKSv5* proxy is preferred as it provides added security.


### Tor instances

To create more *Tor* instances, we can mount additional files with this command:

    docker run -p 8118:8118 -p 4447:4447 -p 9050:9050 \
      -v "${PWD}/tor.ini:/etc/supervisor.d/tor.ini \
      -v "${PWD}/instances:/etc/tor/instances \
      docker.io/aguslr/privoxy-i2p-tor:latest

An example for `tor.ini`:

    [program:tor1]
    stdout_logfile=/dev/stdout
    stdout_logfile_maxbytes=0
    stderr_logfile=/dev/stderr
    stderr_logfile_maxbytes=0
    user=tor
    command=/usr/bin/tor -f /etc/tor/instances/1/torrc

And an example for a *Tor* instance located in `./instances/1/torrc`:

    SocksPort 0.0.0.0:9051
    Log notice stderr
    DataDirectory /var/lib/tor/1
    ExitNodes {es}


Build locally
-------------

Instead of pulling the image from a remote repository, you can build it locally:

1. Clone the repository:

       git clone https://github.com/aguslr/docker-privoxy-i2p-tor.git

2. Change into the newly created directory and use `docker-compose` to build and
   launch the container:

       cd docker-privoxy-i2p-tor && docker-compose up --build -d


[1]: https://github.com/aguslr/docker-privoxy-i2p-tor
[2]: https://www.privoxy.org/
[3]: https://geti2p.net/
[4]: https://torproject.org/
[5]: https://web.archive.org/web/https://www.stupidproxy.com/how-to-use-proxy/
[6]: https://en.wikipedia.org/wiki/.i2p
[7]: https://en.wikipedia.org/wiki/.onion
