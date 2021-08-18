# ansible-controller
Centos7 image with:
* Ansible
* python2.7
* Docker
* docker-compose

The following system packages is installed on control machine.

* ansible
* dmidecode
* docker-ce
* git
* jq
* python-dns
* python-netaddr
* python-pip
* rpm-build

The following python packages is installed on the control machine using pip.

* docker
* python-irodsclient
* requests
* urllib3

## Build
```bash
docker build -t mbwali/ansible-controller:latest .
```

## Run Docker in Docker Using dind
For more on run [Docker in Docker](https://devopscube.com/run-docker-in-docker/)
```bash
docker run --privileged --name ansible-controller -it -d mbwali/ansible-controller:latest docker:dind
```

## Access container & Enable Docker

```bash
docker exec -it <containerid> bash 
systemctl start docker
systemctl enable docker
systemctl status docker
```

## Check Ansible
```bash
ansible --version
```
