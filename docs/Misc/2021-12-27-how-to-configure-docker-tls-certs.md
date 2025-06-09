---
layout: post
title:  "How to configure docker TLS certs"
date:   2021-12-27 11:34:00 +0800
categories: Util
tags:
- docker
- cert
- tls
---

## 1. Generating the certs

Refer to the comment from BMitch <sup>1</sup>, 
I wrote the shell script `make-certs` for generating the certs for both client and server sides.

```sh
curl -sSL -o make-certs https://raw.githubusercontent.com/cloudecho/util-script/master/cert/make-certs
chmod +x make-certs
```

Use the script to generate the certs.

Let's say the server dns name is `echoyun.demo`, and the server ip is `192.168.10.3`

```sh
./make-certs -d3650 -J/CN=echoyun.demo -Sechoyun.demo -H192.168.10.3
```

## 2. Configuration of the client-side

```sh
cd echoyun.demo
mkdir -p ~/.docker/certs
sudo cp client-cert.pem ~/.docker/certs/cert.pem
sudo cp client-key.pem ~/.docker/certs/key.pem 
sudo cp ca.pem ~/.docker/certs/ca.pem 
```

Configure the envrionment variables by editing `~/.bash_profile` or `~/.profile`

```sh
export DOCKER_TLS_VERIFY="1"
export COMPOSE_TLS_VERSION=TLSv1_2
export DOCKER_HOST="tcp://echoyun.demo:2376"
export DOCKER_CERT_PATH="$HOME/.docker/certs"
```

??? note "configure `/etc/hosts` if need"
    
    ```
    192.168.10.3  echoyun.demo
    ```
    
## 3. Configuration of the server-side

Copy the three files to the server which the docker daemon is runing on

* `ca.pem`
* `server-cert.pem`
* `server-key.pem`

and put them under a diretory e.g. `/var/lib/docker/certs/`

Then configure the docker daemon:

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/docker.conf 
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock
EOF

cat <<EOF | sudo tee /etc/docker/daemon.json 
{
  "tls": true,
  "tlscacert": "/var/lib/docker/certs/ca.pem",
  "tlscert": "/var/lib/docker/certs/server-cert.pem",
  "tlskey": "/var/lib/docker/certs/server-key.pem",
  "hosts": ["fd://", "tcp://0.0.0.0:2376"]
} 
EOF
```

Remember to enable and start `containerd` if it hasn't been started:

```sh
sudo systemctl enable containerd
sudo systemctl start containerd
systemctl status containerd
```

Finally, restart docker daemon:

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
systemctl status docker
```

## 4. Testing on the client

```sh
$ docker info
... ...

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 15
 Server Version: 20.10.11
 ... ...
```

## Reference

1. https://stackoverflow.com/questions/38286564/docker-tls-verify-docker-host-and-docker-cert-path-on-ubuntu
2. https://blog.cadena-it.com/linux-tips-how-to/configuring-ssl-requests-with-subjectaltname-with-openssl/
